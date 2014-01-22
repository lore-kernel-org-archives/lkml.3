Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaAVMwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:52:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaAVMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:52:30 -0500
Date: Wed, 22 Jan 2014 13:52:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@parisplace.org>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Slab corruption in fanotify_free_event()
Message-ID: <alpine.LNX.2.00.1401221347240.27143@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

booting current Linus' tree (df32e43a), I am getting

 Slab corruption (Not tainted): fanotify_event_info start=ffff8800372e3320, len=64
 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
 Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
 030: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
 Prev obj: start=ffff8800372e32c8, len=64
 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
 Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 Next obj: start=ffff8800372e3378, len=64
 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
 Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

I guess this is due to

	commit 7053aee26a3548ebaba046ae2e52396ccf56ac6c
	Author: Jan Kara <jack@suse.cz>
	Date:   Tue Jan 21 15:48:14 2014 -0800

	    fsnotify: do not share events between notification groups

as I am not able to see any other recent changes in that area. Haven't 
been looking at the patch closely enough to debug this yet ... sending 
this as an early heads-up.

-- 
Jiri Kosina
SUSE Labs
