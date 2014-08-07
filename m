Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaHGGNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:13:32 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55586 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbaHGGNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:13:30 -0400
Message-ID: <53E31904.9040909@redhat.com>
Date: Thu, 07 Aug 2014 08:13:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com> <53E236E6.6050206@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB5264D@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AB5264D@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/08/2014 03:31, Zhang, Yang Z ha scritto:
> Let me give an example to see whether my concern is a real problem: 
> Guest allocates a vector and set it in IOAPIC entry to deliver
> interrupt. Later it masks the IOAPIC entry(means stop the
> corresponding device) and assign this vector to a MSI device. With
> this patch, even the vector is not used by IOAPIC, but it still set
> eoi exit bitmap unconditionally. The subsequent EOIs to MSI device
> will force vmexit. Could this happen?

Yes, I guess it could.  I'm not sure whether it could on Linux or Windows.

> I think the right fixing is to check the ISR plus TMR to construct
> the eoi exit bitmap.

Do you care enough to propose a patch? :)

Paolo
