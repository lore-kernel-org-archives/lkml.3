Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3H0DmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:42:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41844 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3H0Dl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:41:58 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-25-521c200310f3
Message-ID: <521C1FFF.5060203@hitachi.com>
Date: Tue, 27 Aug 2013 12:41:51 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
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
Subject: Re: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec()
 from deadlocking of ioapic_lock
References: <20130819081220.24406.15846.stgit@yunodevel> <20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com> <871u5or7qn.fsf@tw-ebiederman.twitter.com> <20130820142740.GO239280@redhat.com> <5215CDEF.30004@hitachi.com> <20130822131137.GL5564@redhat.com>
In-Reply-To: <20130822131137.GL5564@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

Sorry for the late reply.

(2013/08/22 22:11), Don Zickus wrote:
> On Thu, Aug 22, 2013 at 05:38:07PM +0900, Yoshihiro YUNOMAE wrote:
>>> So, I agree with Eric, let's remove the disable_IO_APIC() stuff and keep
>>> the code simpler.
>>
>> Thank you for commenting about my patch.
>> I didn't know you already have submitted the patches for this deadlock
>> problem.
>>
>> I can't answer definitively right now that no problems are induced by
>> removing disable_IO_APIC(). However, my patch should be work well (and
>> has already been merged to -tip tree). So how about taking my patch at
>> first, and then discussing the removal of disabled_IO_APIC()?
>
> It doesn't matter to me.  My orignal patch last year was similar to yours
> until it was suggested that we were working around a problem which was we
> shouldn't touch the IO_APIC code on panic.  Then I wrote the removal of
> disable_IO_APIC patch and did lots of testing on it.  I don't think I have
> seen any issues with it (just the removal of disabling the lapic stuff).

Yes, you really did a lot of testing about this problem according to
your patch(https://lkml.org/lkml/2012/1/31/391). Although you
said jiffies calibration code does not need the PIT in
http://lists.infradead.org/pipermail/kexec/2012-February/006017.html,
I don't understand yet why we can remove disable_IO_APIC.
Would you please explain about the calibration codes?

By the way, can we remove disable_IO_APIC even if an old dump capture
kernel is used?

Thanks,
Yoshihiro YUNOMAE

> Regardless, your patch fixes a similar problem we saw on RHEL, so I am
> happy either way.  The removal of the disable_IO_APIC() just makes the
> code look cleaner.
>
> Cheers,
> Don
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


