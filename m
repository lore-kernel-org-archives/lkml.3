Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbbATV6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:58:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40757 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbATV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:58:38 -0500
Date: Tue, 20 Jan 2015 21:58:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Paul Moore <pmoore@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120215831.GJ29656@ZenIV.linux.org.uk>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
 <20150120210202.GI29656@ZenIV.linux.org.uk>
 <20150120213858.GA18129@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120213858.GA18129@kria>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:38:58PM +0100, Sabrina Dubroca wrote:

> [    1.538646] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
> [    1.539704] fn_lookup bsg 0, ffff88001f718000 bsg
> [    1.540559] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
> [    1.552611] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
> [    1.553689] fn_lookup bsg 0, ffff88001f718000 bsg
> [    1.554505] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
> [    1.557554] fn_lookup sda 0, ffff88001f718000 sda
> [    1.558368] fn_lookup sda 0, ffff88001f718000 sda
> [    1.564190] fn_lookup sda1 0, ffff88001f718000 sda1
> [    1.565008] fn_lookup sda1 0, ffff88001f718000 sda1
> [    1.570751] fn_lookup /dev/ram -2, ffff88001f71a300 /dev/ram
> [    1.571786] fn_lookup /dev/root -2, ffff88001f71b480 /dev/root

Nuts...  Is reverting just this (do_path_lookup()) part of commit sufficient
to recover the normal behaviour?
