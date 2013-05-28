Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3E1TBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:01:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39803 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3E1TBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:01:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130528143756.GD7088@redhat.com>
References: <51A02E50.5020507@gmail.com> <87mwri8wwu.fsf@xmission.com> <20130528143756.GD7088@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 28 May 2013 12:00:45 -0700
To: Vivek Goyal <vgoyal@redhat.com>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <ec5cd077-c314-49d5-8970-439ffb9539fa@email.android.com>
X-XM-AID: U2FsdGVkX1/yxadEiWZ9CnFPTOF9etRx88O4JPOUdmA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0028]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>
>Should we schedule the removal of this interface after 1-2 releases
>and give a warning once if anybody opens /dev/oldmem and tell them
>to use /proc/vmcore instead? 

How can anyone use /dev/oldmem correctly?  To the best of
my knowledge there are no parsers of the ELF header passed
by /sbin/kexec in userspace.

If there is anyone who cares they can complain and we can
revert the removal. All of the evidence is that everyone uses
/proc/vmcore.

>I am kind of inclined towards warning approarch. If there is any xyz
>/dev/oldmem user in the wild out there, he/she atleast gets a chance to
>migrate to /proc/vmcore.

If there is a user out there that does not choose to participate
in the community, or pay someone to participate on their
behalf, it saddens me but I don't care.

All someone has to do is to keep a weather eye on the kexec
mailing list, the linux kernel mailing list or simply run a test
kernel, and tell us that they use /dev/oldmem.  That is grounds
under the no regression rule for a revert.

At a practical level a user who does not care will likely be using
a frozen kernel and won't notice until they finally decide to
upgrade their kernel, in several years time.

I don't think we should carry an apparently dead interface
around for the next five years on the off chance someone uses
it.  Especially with no users and no one who cares we won't
maintain the interface properly and it will bit rot and be
broken.

Which means if there is someone using /dev/oldmem we have
a choice of what to do in 5 years time when someone notices.
- Field a bug report about someones kdump implementation
  acting weird.
- Deal with a report of someones kdump implementation not
  working because /dev/oldmem is gone.

With /dev/oldmem gone at least we will be able to get to the root cause of the problem.  -ENODEV.

Which is a long way of saying this is the time for anyone who uses /dev/oldmem to speak now or forever hold their piece.

Eric
