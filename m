Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3ISRFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:05:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53193 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3ISRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:05:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
	<87pps5dr3f.fsf@tw-ebiederman.twitter.com>
	<20130919123812.GA4467@mtj.dyndns.org>
Date: Thu, 19 Sep 2013 12:03:08 -0500
In-Reply-To: <20130919123812.GA4467@mtj.dyndns.org> (Tejun Heo's message of
	"Thu, 19 Sep 2013 07:38:12 -0500")
Message-ID: <87six0922b.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+cUqbCe1nh2Q7cHaf+nnrUeFgVGNP25DY=
X-SA-Exim-Connect-IP: 98.172.60.222
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0324]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] sysfs: implement sysfs_remove()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am running from memory right now.  But the short version is.

Al Viro has complained about the sysfs removal antics of sysfs, and
I have seen Al get confused and "fix" filesystems that depart too far
from normal filesystem semantics.

I have gone down this path both ways and "rm -rf" semantics are horrible
and cause real bugs in the kernel at the boundaries between devices.
"rm -rf" semantics are also horrible because no sanity checks can be
performed.

Normal "unlink/rmdir" semantics are absolutely achievable including
not allowing children to be removed before their parents with just
a few bug fixes to the kernel.  I ran out of energy before I could
track down and make those bug fixes which is why things are left
in the current state.  And now we don't need any more boiler plate
to get there, the current primary interfaces to sysfs remember all of
the filenames.

The fact we actually need to allow parents to be deleted before their
children today to support pci is absoltuely broken.  It is a simple
matter of code bugs.  The device tree semantics are tree semantics not
random order semantics.

I will aim to take a second look when I can spend a little more time
and give you more concrete reasons (other than the old NAK from Viro)
about why recursive sysfs directory removal can cause real bugs.  It is
just subtle enough I can't remember the set of the problems in detail
and a quick look at the code is not enough to remind me.  But I have run
into real issues with even the limited recursive remvoval that sysfs
does today.

Eric
