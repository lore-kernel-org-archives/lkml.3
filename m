Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBPBW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 20:22:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34100 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBPBWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 20:22:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<87bny8kqik.fsf_-_@xmission.com>
	<CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
	<CA+55aFzfa3=ukGq=XJbxj-xqud32DvbF7AcroBKL6-GY32or7Q@mail.gmail.com>
	<87a9ds55av.fsf@xmission.com>
	<CA+55aFyQntJjtVDJ1BsWGaPA5YY96ZjWJSxz-unjWU-RaQiFjw@mail.gmail.com>
Date: Sat, 15 Feb 2014 17:22:41 -0800
In-Reply-To: <CA+55aFyQntJjtVDJ1BsWGaPA5YY96ZjWJSxz-unjWU-RaQiFjw@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 15 Feb 2014 16:03:53 -0800")
Message-ID: <878utb3l7i.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+sghsv6k1JftPEnjF2r/9nCM1yWPDPPRc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 02/11] vfs: More precise tests in d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Feb 15, 2014 at 3:23 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Except that today d_invalidate drops the dcache lock and
>> calls shrink_dcache_parent.  Which gets you into exactly the same
>> complex "walk parents and check all siblings" code.
>
> Hmm. It only does that for directories that have sub-entries, though.
>
> I think you may care just about directories (because that's what your
> series is about), but d_invalidate() is used for other cases too,
> notably d_revalidate() (ie things like stale NFS lookups of normal
> files).
>
> That said, I'll have to think about this more. If d_subdir is empty, I
> guess d_walk() will be fairly cheap. It's very different, but maybe
> not as disastrous as I thought.

Thank you for taking the time to look.

It is also very true that I have been mostly focusing on the semantics
and correctness rather than on the performance of these changes.

I did keep a weather eye on the performance impact of these changes
though and as long as we can stand a slow down in the rare case where
mount points are present my changes should be fine.

Eric
