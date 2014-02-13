Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaBMURw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:17:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38287 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaBMURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:17:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi\@suse.cz" <mszeredi@suse.cz>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
	<CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
	<CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
	<16729.1392318161@warthog.procyon.org.uk>
	<CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com>
Date: Thu, 13 Feb 2014 12:17:37 -0800
In-Reply-To: <CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 13 Feb 2014 11:32:31 -0800")
Message-ID: <87r47622e6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/fHmvfQ6Djz74WK4yiyIaxHKt9AgpA4W8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3787]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 00/13] cross rename v4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Feb 13, 2014 at 11:02 AM, David Howells <dhowells@redhat.com> wrote:
>>
>> Whilst that does seem reasonable, what about all the other software that
>> iterates over a directory?  Some of that is surely not going to know about
>> DT_WHT.
>
> So?
>
> Remeber: whiteout entries do not exist "normally". No normal apps
> should care or see them, since the whole and only point of them is
> when they are part of a union mount (in which case they are not
> visible).
>
> So the "how do you see whiteouts" is really only about the raw
> filesystem mount when *not* in the normal place.
>
> IOW, it's not like these guys are going to show up in users home
> directories etc. It's more like a special device node than a file - we
> need to care about some basic system management interfaces, not about
> "random apps". So "coreutils" is the primary user, although I guess a
> few IT people would prefer for things like Nautilus etc random file
> managers to be able to show them nicely too. But if they show up as an
> icon with a question mark on them or whatever, that's really not a big
> deal either.
>
> Sure, maybe they'll look odd in some graphical file chooser *if*
> somebody makes them show up, but I think creation of a whiteout - if
> we allow it at all outside of the union mount itself - should be a
> root-only thing (the same way mknod is) so quite frankly, it falls
> under "filesystem corruption makes my directory listings look odd -
> cry me a river".
>
> (I do think we should allow creation - but for root only - for
> management and testing purposes, but I really think it's a secondary
> issue, and I do think we should literally use "mknod()" - either with
> a new S_IFWHT or even just making use of existing S_IFCHR just so you
> could use the user-space "mknod" to create it with some magic
> major/minor combination.

I see two interesting questions.

- How do I backup and restore my top layer of my union mount/filesystem?
- How do I use union mounts without in a container?

Backup and restore argues that mknod be able to create these things, and
unlink be able to remove them.  rename shrug.

I expect whiteouts on a filesystem will all belong to some inode with
i_nlink == 0, and likely is not even represented on disk.

Using union mounts in a container effectively boils down to letting
non-root users create these things, so unless applications handle these
very badly I don't know why we should restrict their creation to
root.  Quotas restrict the size of directories and the number of inodes
you can have, and the number of directory blocks you can have, which
handles everything except applications that misbehave in the face of the
unknown.

Eric
