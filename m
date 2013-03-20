Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab3CTTlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:41:13 -0400
Received: from science.horizon.com ([71.41.210.146]:56940 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755567Ab3CTTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:41:10 -0400
Date: 20 Mar 2013 15:41:08 -0400
Message-ID: <20130320194108.24192.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being so very late to the party, but rather than messing
with xattrs, why not just have a specific file (say, default /.whiteout,
but selectable via a mount option) and links to it are counted as
whiteout entries?

All you need to do is resolve the link (it's probably a good idea
to allow symlinks to avoid hard-link count limits) and compare the
fs and inode number.

It's kind of hackish, but it could be done on pretty much *any* Unix
file system.  VFAT would be SOL, but that's probably acceptable.

(Any security options on mount point crossing or consistent ownership
of symlinks that you want to impose would probably be of general VFS
use, and again, not FS-specific.)
