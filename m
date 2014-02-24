Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBXXoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:44:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50501 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaBXXnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:43:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<8761ogkqhl.fsf_-_@xmission.com>
	<20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu>
	<87ha7wrtyz.fsf@xmission.com>
	<CA+55aFx8nksLjQt3aECVk2Ni5FNPXxL988mEqfFgqbbubZho6w@mail.gmail.com>
	<20140219132319.79bc3b26bad00a513880d207@canb.auug.org.au>
Date: Mon, 24 Feb 2014 15:43:34 -0800
In-Reply-To: <20140219132319.79bc3b26bad00a513880d207@canb.auug.org.au>
	(Stephen Rothwell's message of "Wed, 19 Feb 2014 13:23:19 +1100")
Message-ID: <87ios4gjq1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Z+9PwxM4p19MAUtQXur7GPuI7OK47s4Y=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.1 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 03/11] vfs: Don't allow overwriting mounts in the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> On Tue, 18 Feb 2014 14:20:29 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> For this kind of function return value it actually tends to work very
>> well, and in fact often generates slightly better code than "int". So
>> I don't _hate_ bool, and we've certainly had a lot more use creep in
>> lately, but I also don't really see "bool" as much of an upside.
>
> And in function declarations, it makes it very obvious that the function
> is not one of our "return 0 or -ERROR" ones.

So I played with this instance in particular.  The only difference winds
up being by the bool version uses byte instructions on %al and %bl
instead of their 32 bit interger equivalents on %eax and %ebx.

I also benchmarked the difference and on the most sensitive test I could
find.  will-it-scale/unlink2 (aka create,close,unlink each process in a
separate directory).  There were no measurable performance differences.

So for purposes of better documentation I have changed the function, and
I will repost my patches shortly.

Eric
