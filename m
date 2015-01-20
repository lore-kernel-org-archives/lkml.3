Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbbATVCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:02:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbATVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:02:12 -0500
Date: Tue, 20 Jan 2015 21:02:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Paul Moore <pmoore@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120210202.GI29656@ZenIV.linux.org.uk>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120204504.GA309@kria>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:45:04PM +0100, Sabrina Dubroca wrote:

> printk(KERN_ERR "fn_lookup %s %d\n", name, retval);
> 
> and I get:
> 
> [    1.618558] fn_lookup bsg/0:0:0:0 -2
> [    1.619437] fn_lookup bsg 0
> [    1.620236] fn_lookup bsg/0:0:0:0 -2
> [    1.625996] fn_lookup sda 0
> [    1.626609] fn_lookup sda 0
> [    1.639007] fn_lookup sda1 0
> [    1.639691] fn_lookup sda1 0
> [    1.643656] fn_lookup bsg/1:0:0:0 -2
> [    1.644974] fn_lookup bsg 0
> [    1.645928] fn_lookup bsg/1:0:0:0 -2
> [    1.649483] fn_lookup /dev/ram -2
> [    1.650424] fn_lookup /dev/root -2
> [    1.651234] VFS: Cannot open root device "sda1" or unknown-block(8,1): error -2

That -2 is -ENOENT...  Wait a sec, what's in filename, filename->name and
what do you get from your printk on kernel with that commit reverted?
