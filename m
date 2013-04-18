Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967683Ab3DRQfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:35:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43555 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967649Ab3DRQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:35:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: linux-watchdog@vger.kernel.org, kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com, Guenter Roeck <linux@roeck-us.net>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
Date: Thu, 18 Apr 2013 09:35:05 -0700
In-Reply-To: <1366233596-34681-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Wed, 17 Apr 2013 17:19:56 -0400")
Message-ID: <87ip3j94qu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/YMiPgLrkOpKRadtmpm4UvHTQvNyWksEQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
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

Having thought about this a little more this patch is actively wrong.

The problem is you can easily be petting the watchdog in violation of
whatever policy is normally in place.  Which means that this extra
petting can result in a system that is unavailable for an unacceptably
long period of time.

I expect most watchdog policies are not that strict, but this patch
would preclude using those that are.

And like is being discussed in another subthread it does look like
changing the timeout and the interval should be enough all on it's own.

Eric
