Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3KXBD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 20:03:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41110 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3KXBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 20:03:57 -0500
Date: Sun, 24 Nov 2013 01:03:16 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Howard Chu <hyc@symas.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chinmay V S <cvs268@gmail.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131124010316.2ca6a8ce@alan.etchedpixels.co.uk>
In-Reply-To: <20131124002236.GA10600@amd.pavel.ucw.cz>
References: <528CA73B.9070604@profihost.ag>
	<20131120125446.GA6284@infradead.org>
	<CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
	<528CC36A.7080003@profihost.ag>
	<CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
	<20131120153703.GA23160@thunk.org>
	<528CDD19.5060002@symas.com>
	<20131123203600.GA791@amd.pavel.ucw.cz>
	<529133CC.4070904@gmail.com>
	<20131124002236.GA10600@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, and I'm arguing that is a bug (as in, < 0.01% people are using
> hdparm correctly).

Generally speaking if you are using hdparm for tuning it means we need to
fix something in the ATA layer so you don't have to !

> I guess it would be safer not to reattach drives after power
> fail... (also I wonder what this does to data integrity. Drive lost
> content of its writeback cache, but kernel continues... Journal will
> not prevent data corruption in this case).

For good or bad its very hard to tell if a drive randomly powers off or
we merely get a bus reset in the ATA case. In the SATA case we do at
least get the relevant events to handle it nicely as we *should* see a
DevExch event. We also can't tell a power fail event from a hot drive
swap, so we most definitely want to re-attach the drive, just so long as
we ensure that it comes back on a different device node.

Alan
