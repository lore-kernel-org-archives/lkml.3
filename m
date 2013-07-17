Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3GQFng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:43:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47149 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3GQFne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:43:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
References: <20130716192920.GA8980@sergelap>
	<20130716193826.GP4165@ZenIV.linux.org.uk>
	<20130716195002.GA23370@mail.hallyn.com> <51E5BC0D.3090303@mit.edu>
	<20130716213748.GA24076@mail.hallyn.com>
	<CALCETrV8QFZU947=OjL-abxAmHiLso-uhbmoJt45kfmtaw26Tg@mail.gmail.com>
	<20130716220301.GA24223@mail.hallyn.com>
	<CALCETrXgU560Vk382xsPJD+uE7EQzqkbCobV8BXwVXrK8EryNw@mail.gmail.com>
	<20130716222308.GA24408@mail.hallyn.com>
Date: Tue, 16 Jul 2013 22:43:17 -0700
In-Reply-To: <20130716222308.GA24408@mail.hallyn.com> (Serge E. Hallyn's
	message of "Tue, 16 Jul 2013 22:23:08 +0000")
Message-ID: <87d2qh91xm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18VBhhi2ifoShP0WXwhTDTC0wQdbq6HCZw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> I'm not "relying on LSM" to make these safe.  I'm relying on the
> uid mappings to make these safe.
>
> Nevertheless I at least have hope of working around the others (in a
> distro-acceptable way), so if the others are too scary I'll pursue
> the workaround for the others and see where I get.  But I really feel
> the securityfs one is the best solution.

Personally I don't trust debugfs enough to compile it into my kernel.

fuse simply isn't ready to be have fresh mounts usefully created inside
a user namespace.

Fundamentally with debugfs and securityfs you run into the issue we saw
with sysfs and proc where at some level it is the system administrators
perogative if those filesystems should be mounted.

The rule with filesystems like that is mounting them needs to be no more
dangerous than bind mounting them.  At the point in the cycle you are
talking about mounting them you presumably have already thrown away
their original mounts making it impossible to tell if it would have been
safe to mount them or not.  Making your patch completely inappropriate.

What you need to do is at container setup time to bind mount those
filesystems if they are already mounted and you want them in the
container.  If you are just shuffling around something you can already
see there are no security issues.

Eric
