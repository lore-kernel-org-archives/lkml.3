Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab3CNM6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:58:03 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:44126 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CNM6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:58:02 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: DT_WHT (Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16))
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>
In-Reply-To: <CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu> <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com> <20130312222350.GK21522@ZenIV.linux.org.uk> <20130313185249.GL21522@ZenIV.linux.org.uk> <CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com> <20130313231918.GP21522@ZenIV.linux.org.uk> <CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
Date: Thu, 14 Mar 2013 21:57:46 +0900
Message-ID: <1402.1363265866@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> On Thu, Mar 14, 2013 at 12:19 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
	:::
> > As for whiteouts... I think we ought to pull these bits of unionmoun
> > queue into the common stem and add the missing filesystems to them;
> > ext* and ufs are trivial (keep in mind that FFS derivatives, including
> > ext*, have d_type in directory entry and type 14 (DT_WHT) is there
> > precisely for that purpose).  btrfs also has "dir_type" thing - 8bit
> > field...
>
> What about userspace interfaces?  Are we allowed to extend d_type and
> st_mode without breaking things?

Introducing a new d_type value can be a headache for other filesystems
or other OSs. Whiteout and opaque by xattr is an idea, but I prefer more
primitive way (special hidden filename) since xattr may force users to
change their configuration and it consumes disk space a little.
Filesystems may have a limit for the consumed size by xattr. If xattr
reaches the limit, then several operation in overlayfs will be unusable.


J. R. Okajima
