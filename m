Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423153Ab3DFPWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 11:22:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55869 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423041Ab3DFPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 11:22:50 -0400
Date: Sat, 6 Apr 2013 16:22:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] fsfreeze: from uninterruptible to killable waiting
Message-ID: <20130406152247.GJ4068@ZenIV.linux.org.uk>
References: <515FF2D4.2050307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515FF2D4.2050307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 12:03:00PM +0200, Marco Stornelli wrote:
> Hi all,
> 
> with this patch series we try to change the fs freeze behavior in order
> to sleep in a killable state instead of sleeping in uninterruptible 
> state. The patches are *NOT* tested because but a first review is welcome.
> The design is simply:
> 
> 1) Internal fs operations are not changed from fsfreeze point of view, 
> sb_start_intwrite is not changed;
> 
> 2) sb_start_write and sb_start_pagefault now return a proper error code 
> if the process receive SIGKILL and all the functions must manage this 
> error and return EINTR or VM_FAULT_RETRY.

sb_start_write() is done _way_ too deep in the call chain in the mainline;
check the changes in -next, please.
