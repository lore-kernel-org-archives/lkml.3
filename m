Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3JHUxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:53:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40549 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3JHUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:53:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 08 Oct 2013 13:50:14 -0700
In-Reply-To: <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 8 Oct 2013 18:11:35 +0200")
Message-ID: <87li23trll.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/miVoVhvl5b7/nEgzT0zp7xLa+J1oa3OQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Tue, Oct 08, 2013 at 09:06:29AM -0700, Andy Lutomirski wrote:
>
>> > I think the risks of changing behavior outweigh the benefits.  How many
>> > times did you have to remove or rename a mounted file or directory?  It's
>> > very rarely needed.
>> 
>> I do this every time I reinstall a system while running that system.
>> Admittedly, mount --move works, but that's a really unpleasant
>> interface.
>> 
>> When rename2 gets added, there could be a flag RENAME_MOVE_MOUNT to opt in.
>
> Good point.  Opting in would be the safest for both unlinkat() and
> renameat2().

Opting in to allowing mounts to be unlinked and renamed?  Or opting in
to not renaming/unlinking a mount point?

I can see opting in to denying the rename/unlink if that is someting
someone wants for some reason.  With an opt in we can even use the
previous d_mountpoint check and not stomp someone's else's weird set of
mounts in some other mount namespace if they are on the local machine
and that is desired.



The rmdir non-empty dir semantics justify blocking rmdir.



If we are going to fix the VFS deficiency we have to let these changes
happen in other mount namespaces.  To make that safe it has to be
sufficient to rely on the directory permissions and the conditions that
ensure that the directory permissions are sufficient.

So I find it far safer to allow as much as possible even in the local
mount namespace so we can actually see if there are problems with
relying on the directory permissions.

Eric

