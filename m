Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaLCEh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:37:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaLCEhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:37:55 -0500
Message-ID: <547E939F.40106@suse.com>
Date: Wed, 03 Dec 2014 05:37:51 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Joerg Roedel <jroedel@suse.de>, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, Borislav Petkov <bp@suse.de>,
        Olaf Hering <ohering@suse.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private hypercall
 when non CONFIG_PREEMPT
References: <20141127183616.GV25677@wotan.suse.de> <547C4CEF.1010603@citrix.com> <20141201150546.GC25677@wotan.suse.de> <547C86BF.2040705@citrix.com> <CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com> <547C8F30.1010306@citrix.com> <20141201161905.GH25677@wotan.suse.de> <547CB07C.1050507@citrix.com> <20141201223611.GM25677@wotan.suse.de> <547D9E56.50708@citrix.com> <20141203022833.GS25677@wotan.suse.de>
In-Reply-To: <20141203022833.GS25677@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 03:28 AM, Luis R. Rodriguez wrote:
> On Tue, Dec 02, 2014 at 11:11:18AM +0000, David Vrabel wrote:
>> On 01/12/14 22:36, Luis R. Rodriguez wrote:
>>>
>>> Then I do agree its a fair analogy (and find this obviously odd that how
>>> widespread cond_resched() is), we just don't have an equivalent for IRQ
>>> context, why not avoid the special check then and use this all the time in the
>>> middle of a hypercall on the return from an interrupt (e.g., the timer
>>> interrupt)?
>>
>> http://lists.xen.org/archives/html/xen-devel/2014-02/msg01101.html
>
> OK thanks! That explains why we need some asm code but in that submission you
> still also had used is_preemptible_hypercall(regs) and in the new
> implementation you use a CPU variable xen_in_preemptible_hcall prior to calling
> preempt_schedule_irq(). I believe you added the CPU variable because
> preempt_schedule_irq() will preempt first without any checks if it should, I'm
> asking why not do something like cond_resched_irq() where we check with
> should_resched() prior to preempting and that way we can avoid having to use
> the CPU variable?

Because that could preempt at any asynchronous interrupt making the
no-preempt kernel fully preemptive. How would you know you are just
doing a critical hypercall which should be preempted?

Juergen

