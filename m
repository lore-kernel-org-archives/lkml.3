Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaE2L33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaE2L32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:29:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <27993.1401360881@warthog.procyon.org.uk>
References: <27993.1401360881@warthog.procyon.org.uk> <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: Kernel errors with overlay filesystem v22
Date: Thu, 29 May 2014 12:28:45 +0100
Message-ID: <28313.1401362925@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This sequence of commands produces both errors:

 mount -t tmpfs lower_layer /lower
 mount -t tmpfs upper_layer /upper
 mkdir /upper/upper
 mkdir /upper/work
 mount -t overlayfs overlayfs /mnt -olowerdir=/lower,upperdir=/upper/upper,workdir=/upper/work
 # The lockdep error was reported in the above mount command
 umount /mnt
 umount /upper
 # The dentry leak error was reported in the last umount command

where /lower, /upper and /mnt are preexisting directories.

Note that prior to this, mounting and unmounting a tmpfs filesystem worked
with no errors.

David
