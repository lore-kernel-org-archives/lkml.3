Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3CUUrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:47:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3CUUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:47:08 -0400
Date: Thu, 21 Mar 2013 20:47:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321204704.GZ21522@ZenIV.linux.org.uk>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321203639.GC16406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 04:36:39PM -0400, Dave Jones wrote:
> at some point during the fuzz run, this happened..
> 
> Mar 20 15:20:41 kernel: [ 7578.784674] fuse init (API version 7.21)
> Mar 20 15:20:41 systemd[1]: Mounting FUSE Control File System...
> Mar 20 15:20:41 systemd[1]: Mounted FUSE Control File System.
> 
> I guess something wandered into /dev/fuse and did something. Not sure why 
> systemd reacted though...

AFAICS, fuse uses d_materialise_unique() and d_splice_alias(), though, so
it's not too likely source of that crap; there's no d_instantiate() calls
at all and the sole d_add() is using an inode that has just been allocated,
so it won't be creating aliases either...
