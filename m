Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3D2Qql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:46:41 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:41197 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3D2Qqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:46:40 -0400
Message-ID: <517EA3DA.3070706@redhat.com>
Date: Mon, 29 Apr 2013 18:46:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: linux-next: Tree for Apr 29 (kvm)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au> <517E9758.4000506@infradead.org> <20130429163135.GA2737@redhat.com>
In-Reply-To: <20130429163135.GA2737@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/04/2013 18:31, Gleb Natapov ha scritto:
>> > arch/x86/kvm/x86.c: In function 'kvm_dev_ioctl_check_extension':
>> > arch/x86/kvm/x86.c:2547:22: error: 'pci_bus_type' undeclared (first use in this function)
>> > 
>> > 
>> > Oops, CONFIG_PCI is not enabled.
> Alex, can you look at this please. Before "kvm: Allow build-time configuration
> of KVM device assignment" commit KVM depended on PCI to be enabled.
> 

KVM_CAP_IOMMU probably should depend on device assignment.  It doesn't
really belong in KVM at all, and is only there for device assignment.

Paolo
