Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3HTKOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:14:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60906 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HTKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:14:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
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
In-Reply-To: <5212B31A.6090504@hitachi.com> (Yoshihiro YUNOMAE's message of
	"Tue, 20 Aug 2013 09:06:50 +0900")
References: <20130819081220.24406.15846.stgit@yunodevel>
	<20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 20 Aug 2013 03:12:32 -0700
Message-ID: <871u5or7qn.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX191Xayd+0JHUOjymd2EhKtoeVW8fItt6vI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0262]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from deadlocking of ioapic_lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> writes:

> Hi Ingo,
>
> Thank you for fixing typos!
> OK, I'll fix them and rename to ioapic_zap_locks().
>
> Thank you again!


The better fix for this would be to remove the disable_IO_APIC call from
crash_kexec.

I know last time it was investigated the kernel was very close to
working without needing that, and the code will be much more robust in
the long term if we can avoid disabling them in the crashing kernel.

Yoshihiro is there any chance you can look into removing the
disable_IO_APIC entirely?

The apic disablement and the disable_IO_APIC exists entirely due to
limitations in the kernel boot path.

Eric
