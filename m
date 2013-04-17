Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966889Ab3DQVuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:50:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49008 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab3DQVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:50:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: linux-watchdog@vger.kernel.org, kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com, linux@roeck-us.net
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
Date: Wed, 17 Apr 2013 14:49:59 -0700
In-Reply-To: <1366233596-34681-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Wed, 17 Apr 2013 17:19:56 -0400")
Message-ID: <87li8gaku0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1//njfYdczlmhsHkOn/mo8f4Y9BuKzsByE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Don Zickus <dzickus@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> A common problem with kdump is that during the boot up of the
> second kernel, the hardware watchdog times out and reboots the
> machine before a vmcore can be captured.
>
> Instead of tellling customers to disable their hardware watchdog
> timers, I hacked up a hook to put in the kdump path that provides
> one last kick before jumping into the second kernel.
>
> The assumption is the watchdog timeout is at least 10-30 seconds
> long, enough to get the second kernel to userspace to kick the watchdog
> again, if needed.

Why not double the watchdog timeout? and/or pet the watchdog a little
more frequently.

This is the least icky hook I have seen proposed to be put on the kexec
on panic path, but I still suspect this may reduce the ability to take a
crash dump.  What happens if it was the watchdog timer that panic'd for
example.

Eric
