Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3EYXZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 19:25:49 -0400
Received: from etrn.xmission.com ([198.60.22.17]:36613 "EHLO etrn.xmission.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177Ab3EYXZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 19:25:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51A02E50.5020507@gmail.com>
Date: Sat, 25 May 2013 16:25:21 -0700
In-Reply-To: <51A02E50.5020507@gmail.com> (Zhang Yanfei's message of "Sat, 25
	May 2013 11:21:52 +0800")
Message-ID: <87mwri8wwu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ua+kVX8toiAnI4TLDCUAHJOJoX/d7YZU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei.yes@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:

> /dev/oldmem provides the interface for us to access the "old memory" in
> the dump-capture kernel. Unfortunately, no one actually uses this interface.
>
> And this interface could actually cause some real problems if used on ia64
> where the cached/uncached accesses are mixed. See the discussion from
> the link: https://lkml.org/lkml/2013/4/12/386.
>
> So Eric suggested that we should remove /dev/oldmem as an unused piece of
> code.
>
> Besides, we used a global variable saved_max_pfn to let the capture kernel
> know the amount of memory that the previous kernel used. And for almost all
> architectures (except x86. In x86, saved_max_pfn is used by detect_calgary()),
> the only user of this variable is the read_oldmem interface of /dev/oldmem, so
> also remove the setting for saved_max_pfn in those architectures.

Except for the devices.txt update.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Zhang Yanfei (7):
>   /dev/oldmem: Remove this interface
>   Documentation/devices.txt: Remove /dev/oldmem description
>   Documentation/kdump/kdump.txt: Remove /dev/oldmem description
>   mips: Remove savemaxmem parameter setup
>   powerpc: Remove savemaxmem parameter setup
>   ia64: Remove setting for saved_max_pfn
>   s390: Remove setting for saved_max_pfn
>
>  Documentation/devices.txt        |    2 -
>  Documentation/kdump/kdump.txt    |   31 +++++--------------------
>  arch/ia64/kernel/efi.c           |    5 ----
>  arch/mips/kernel/crash_dump.c    |   10 --------
>  arch/powerpc/kernel/crash_dump.c |   10 --------
>  arch/s390/kernel/setup.c         |    4 ---
>  drivers/char/mem.c               |   47 --------------------------------------
>  7 files changed, 6 insertions(+), 103 deletions(-)
