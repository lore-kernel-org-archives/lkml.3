Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaKCHRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:17:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKCHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:17:16 -0500
Date: Mon, 3 Nov 2014 07:17:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [vfs] WARNING: CPU: 0 PID: 3 at fs/dcache.c:255 __d_free()
Message-ID: <20141103071711.GZ7996@ZenIV.linux.org.uk>
References: <20141103070142.GB1189@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103070142.GB1189@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:01:42PM +0800, Fengguang Wu wrote:
> Hi Al,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-next
> 
> commit ff1995cbc0eb7c4beeca313a150111e3e3622e2c
> Author:     Al Viro <viro@zeniv.linux.org.uk>
> AuthorDate: Sun Oct 26 19:19:16 2014 -0400
> Commit:     Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Fri Oct 31 13:04:16 2014 -0400
> 

Right, but the warning is a false positive - both of these WARN_ON should
be moved to dentry_free() (both the __d_free() and __d_free_external() ones,
that is).  Will fix and push tomorrow morning...
