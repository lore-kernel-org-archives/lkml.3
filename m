Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3HVIiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:38:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54035 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3HVIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:38:14 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-21-5215cdf3cbdd
Message-ID: <5215CDEF.30004@hitachi.com>
Date: Thu, 22 Aug 2013 17:38:07 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Ingo Molnar <mingo@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from
 deadlocking of ioapic_lock
References: <20130819081220.24406.15846.stgit@yunodevel> <20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com> <871u5or7qn.fsf@tw-ebiederman.twitter.com> <20130820142740.GO239280@redhat.com>
In-Reply-To: <20130820142740.GO239280@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/20 23:27), Don Zickus wrote:
> On Tue, Aug 20, 2013 at 03:12:32AM -0700, Eric W. Biederman wrote:
>> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> writes:
>>
>>> Hi Ingo,
>>>
>>> Thank you for fixing typos!
>>> OK, I'll fix them and rename to ioapic_zap_locks().
>>>
>>> Thank you again!
>>
>>
>> The better fix for this would be to remove the disable_IO_APIC call from
>> crash_kexec.
>>
>> I know last time it was investigated the kernel was very close to
>> working without needing that, and the code will be much more robust in
>> the long term if we can avoid disabling them in the crashing kernel.
>>
>> Yoshihiro is there any chance you can look into removing the
>> disable_IO_APIC entirely?
>>
>> The apic disablement and the disable_IO_APIC exists entirely due to
>> limitations in the kernel boot path.
>
> Yup.  We went down this path a year ago:
>
> https://lkml.org/lkml/2012/2/2/331
>
> Then we got sidetracked and talked about removing the lapic stuff at
> shutdown too:
>
> http://lists.infradead.org/pipermail/kexec/2012-February/006017.html
> (sorry couldn't find lkml link for some reason)
>
> And the second patch was committed.
>
> However, it was quickly reverted when Yinghai Lu noticed a problem:
>
> https://lkml.org/lkml/2012/2/11/143
>
> The problem stemmed from the fact that the nmi_watchdog caused an NMI in
> the middle of transitioning between the two kernels (we didn't shutdown
> the lapic) and caused a reset (there is no NMI handler in purgatory).
>
> I think I dropped the ball in investigating how to write an idt for the
> purgatory code to handle spurious NMIs.
>
> Regardless of all that, I think if we stick to just removing the ioapic
> shutdown code (ie the first patch linked above), we should be ok.  I
> believe my testing went smoothly.  It was the lapic stuff that needed more
> tweaking.
>
> So, I agree with Eric, let's remove the disable_IO_APIC() stuff and keep
> the code simpler.

Thank you for commenting about my patch.
I didn't know you already have submitted the patches for this deadlock
problem.

I can't answer definitively right now that no problems are induced by
removing disable_IO_APIC(). However, my patch should be work well (and
has already been merged to -tip tree). So how about taking my patch at
first, and then discussing the removal of disabled_IO_APIC()?

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


