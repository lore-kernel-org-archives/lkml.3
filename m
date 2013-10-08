Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3JHNQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:16:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44977 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3JHNQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:16:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthias Schniedermeyer <ms@citd.de>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<20131008104202.GA20639@citd.de>
Date: Tue, 08 Oct 2013 06:13:14 -0700
In-Reply-To: <20131008104202.GA20639@citd.de> (Matthias Schniedermeyer's
	message of "Tue, 8 Oct 2013 12:42:02 +0200")
Message-ID: <87ob6zzz11.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+m+8xcp61n2bITdy2wCknEqqlu/bvWPBk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0571]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Matthias Schniedermeyer <ms@citd.de>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer <ms@citd.de> writes:

> On 06.10.2013 23:55, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> So if we can feel safe just depending on the parent directory
>> permissions (which are not hidden by a mount) protecting our mount
>> points, I feel much better about this patchset.
>
> As far as i can tell, the permissions of the host-directory of a 
> mount-point are hidden, at least for user-space.
> (Ignoring (bind-)mounting the parent-mount somewhere else)
>
> As root:
> $ mkdir /tmp/test
> $ ls -ld /tmp/test
> drwxr-xr-x 2 root root 40 Oct  8 12:33 /tmp/test
>
> $ mount tmpfs -t tmpfs /tmp/test
> $ ls -ld /tmp/test
> drwxrwxrwt 2 root root 40 Oct  8 12:33 /tmp/test
>
> $ chown nobody.users /tmp/test
> $ ls -ld /tmp/test
> drwxrwxrwt 2 nobody users 40 Oct  8 12:33 /tmp/test
>
> $ umount /tmp/test
> $ ls -ld /tmp/test
> drwxr-xr-x 2 root root 40 Oct  8 12:33 /tmp/test
>
>
> So if the kernel would check the host-directory-permissions for allowing 
> umounting by rmdir it follows that a "plain user" doesn't have any 
> possibility to know beforehand if rmdir/umount would be possible.

Except the directory that is relevant to unlink/rmdir in your example is /tmp
not /tmp/test.

But thanks for the eyeball.

Eric
