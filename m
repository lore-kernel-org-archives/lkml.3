Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbbATWNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:13:48 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57446 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbATWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:13:46 -0500
Date: Tue, 20 Jan 2015 14:13:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120221309.GA18589@roeck-us.net>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
 <20150120210202.GI29656@ZenIV.linux.org.uk>
 <20150120220823.GB18129@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120220823.GB18129@kria>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54BED319.0270,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:08:23PM +0100, Sabrina Dubroca wrote:
> 2015-01-20, 21:58:31 +0000, Al Viro wrote:
> > On Tue, Jan 20, 2015 at 10:38:58PM +0100, Sabrina Dubroca wrote:
> > 
> > > [    1.538646] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
> > > [    1.539704] fn_lookup bsg 0, ffff88001f718000 bsg
> > > [    1.540559] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
> > > [    1.552611] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
> > > [    1.553689] fn_lookup bsg 0, ffff88001f718000 bsg
> > > [    1.554505] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
> > > [    1.557554] fn_lookup sda 0, ffff88001f718000 sda
> > > [    1.558368] fn_lookup sda 0, ffff88001f718000 sda
> > > [    1.564190] fn_lookup sda1 0, ffff88001f718000 sda1
> > > [    1.565008] fn_lookup sda1 0, ffff88001f718000 sda1
> > > [    1.570751] fn_lookup /dev/ram -2, ffff88001f71a300 /dev/ram
> > > [    1.571786] fn_lookup /dev/root -2, ffff88001f71b480 /dev/root
> > 
> > Nuts...  Is reverting just this (do_path_lookup()) part of commit sufficient
> > to recover the normal behaviour?
> 
> Yes.
> 
Same on microblaze.

Guenter
