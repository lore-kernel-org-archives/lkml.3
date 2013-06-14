Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab3FNCF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:05:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58856 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535Ab3FNCF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:05:26 -0400
Date: Fri, 14 Jun 2013 03:05:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: majianpeng <majianpeng@gmail.com>
Cc: john <john@johnmccutchan.com>, rlove <rlove@rlove.org>,
        eparis <eparis@parisplace.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Using inotify on /proc/partitoins
Message-ID: <20130614020523.GL4165@ZenIV.linux.org.uk>
References: <201306140926455537935@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306140926455537935@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 09:26:49AM +0800, majianpeng wrote:
> Hi all,
>      I wanted to monitor /proc/partitions using inotify.


That, indeed, is a bug.  Easily fixed - don't do that.

> But when i call 'cat /proc/partitions',the program can't return.
> So i added some message in kernel in order to find the reason.
> In procfs for some files, the inode used this method to alloc.
> proc_lookup-->proc_lookup_de--->proc_get_inode-->new_inode_pseudo
> In new_inode_pseudo, it will alloc new inode so every open-operation procfs will alloc new inode.
> So inotify can't work.

Of course, it can't work.  Inotify if a kludge that kinda-sorta works
for local disk-backed filesystems, if you do not mind a pile of races.
For anything else it's completely worthless.
