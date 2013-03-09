Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3CIDil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:38:41 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53538 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454Ab3CIDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:38:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
	<20130309001917.GA6015@redhat.com> <20130309003617.GB6743@redhat.com>
	<CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
	<20130309020318.GA11449@redhat.com>
	<CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
	<20130309022623.GB11449@redhat.com>
	<20130309025631.GA13188@redhat.com>
	<20130309025752.GA13913@redhat.com>
	<CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
	<20130309032530.GA19839@redhat.com>
Date: Fri, 08 Mar 2013 19:38:33 -0800
In-Reply-To: <20130309032530.GA19839@redhat.com> (Dave Jones's message of
	"Fri, 8 Mar 2013 22:25:30 -0500")
Message-ID: <87wqthmedi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+IhuI1YNCShylDyeJCHCK2iuPHK/R2Hs8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Fri, Mar 08, 2013 at 07:16:09PM -0800, Linus Torvalds wrote:
>  > Goodie. Your bug reports gave me heartburn. But it sounds like we have an
>  > angle on all of the ones you've seen now?
>  > 
>  > Or have I forgotten about some case?
>  
> To be honest I've lost track of the whole collection.
> Let me repull your latest tree, and see what falls out.
> (I'll turn off CONFIG_USER_NS for now too until that gets fixed)

It was CONFIG_UTS_NS that tripped you.  

Since I can trigger this with /proc/self/ns/mnt/a you are going to be
able to compile this one out.

Eric
