Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab3CLRcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:32:50 -0400
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:34964 "EHLO
	mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab3CLRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:32:37 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 13:32:36 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Date: Wed, 13 Mar 2013 02:22:13 +0900
Message-ID: <9427.1363108933@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Please consider overlayfs for inclusion into 3.10.

Thank you for CCing me.

First, I'd suggest you to follow some recent activities in mainline
kernel such as
- MODULE_ALIAS_FS
- file_inode()
- d_weak_revalidate() which may not be necessary for overlayfs as long
  as it prohibit users the direct-access to layers (bypassing
  overlayfs).


> It's included in Ubuntu and openSUSE, used by OpenWrt and various other
> projects.  I regularly get emails asking when it will be included in mainline.

Such situation is very similar which AUFS had a few years ago. At that
time, AUFS was rejected since UnionMount was chosen. Years passed, the
development of UnionMount seems to stop and linux mainline doesn't have
generic stackable filesytem yet. I had pointed out some defects in
overlayfs (and UnionMount too). They are all based upon the "name-based"
behaviour instead of "inode-based" one. Other than "Non-standard
behavior" in the overlayfs document, the are, for example,
- read(2) may get an obsoleted filedata (fstat(2) for metadata too).
- fcntl(F_SETLK) may be broken by copy-up.
- inotify may not work when it refers to the file before being
  copied-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).

AUFS is an "inode-based" stackable filesystem and solved them many years
ago. But I have to admit that AUFS is big. Yes it is grown up.
I don't stop including overlayfs into mainline, but if the development
of UnionMount is really stopped, then I'd ask people to consider merging
aufs as well as overlayfs.


J. R. Okajima
