Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaIKObw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:31:52 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:34850 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaIKObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:31:32 -0400
Date: Thu, 11 Sep 2014 17:31:24 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page on
 migration in vcpu_enter_guest().
Message-ID: <20140911143123.GE26540@minantech.com>
References: <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com>
 <541169AD.6060908@redhat.com>
 <20140911101200.GF25317@minantech.com>
 <54117DB4.307@redhat.com>
 <20140911113051.GG25317@minantech.com>
 <54119E01.9000908@redhat.com>
 <20140911135956.GC26540@minantech.com>
 <5411AC82.4080005@redhat.com>
 <20140911142121.GD26540@minantech.com>
 <5411B084.7030800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411B084.7030800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:24:04PM +0200, Paolo Bonzini wrote:
> Il 11/09/2014 16:21, Gleb Natapov ha scritto:
> > As far as I can tell the if that is needed there is:
> > 
> > if (!is_guest_mode() || !(vmcs12->secondary_vm_exec_control & ECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
> >     write(PIC_ACCESS_ADDR)
> > 
> > In other words if L2 shares L1 apic access page then reload, otherwise do nothing.
> 
> What if the page being swapped out is L1's APIC access page?  We don't
> run prepare_vmcs12 in that case because it's an L2->L0->L2 entry, so we
> need to "do something".
We will do something on L2->L1 exit. We will call kvm_reload_apic_access_page().
That is what patch 5 of this series is doing.

--
			Gleb.
