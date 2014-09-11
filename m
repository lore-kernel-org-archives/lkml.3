Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaIKOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaIKOhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:37:53 -0400
Message-ID: <5411B3B3.900@redhat.com>
Date: Thu, 11 Sep 2014 16:37:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <20140911101200.GF25317@minantech.com> <54117DB4.307@redhat.com> <20140911113051.GG25317@minantech.com> <54119E01.9000908@redhat.com> <20140911135956.GC26540@minantech.com> <5411AC82.4080005@redhat.com> <20140911142121.GD26540@minantech.com> <5411B084.7030800@redhat.com> <20140911143123.GE26540@minantech.com>
In-Reply-To: <20140911143123.GE26540@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 16:31, Gleb Natapov ha scritto:
>> > What if the page being swapped out is L1's APIC access page?  We don't
>> > run prepare_vmcs12 in that case because it's an L2->L0->L2 entry, so we
>> > need to "do something".
> We will do something on L2->L1 exit. We will call kvm_reload_apic_access_page().
> That is what patch 5 of this series is doing.

Sorry, I meant "the APIC access page prepared by L1" for L2's execution.

You wrote:

> if (!is_guest_mode() || !(vmcs12->secondary_vm_exec_control & ECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>     write(PIC_ACCESS_ADDR)
> 
> In other words if L2 shares L1 apic access page then reload, otherwise do nothing.

but in that case you have to redo nested_get_page, so "do nothing"
doesn't work.

Paolo
