Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3KTUwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:52:45 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37486 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3KTUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:52:42 -0500
Date: Wed, 20 Nov 2013 20:52:12 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131120205212.2509cb8b@alan.etchedpixels.co.uk>
In-Reply-To: <1384881423.1974.277@driftwood>
References: <20131030120152.GM2400@suse.de>
	<1384881423.1974.277@driftwood>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is assuming your hard drive _itself_ doesn't have bufferbloat, but  
> http://spritesmods.com/?art=hddhack&f=rss implies they don't, and  
> tagged command queueing lets you see through that anyway so your  
> "actually committed" numbers could presumably still be accurate if the  
> manufacturers aren't totally lying.

They don't but they do have wildly variable completion rates and times.
Nothing like a drive having a seven second hiccup to annoy people but
they can do that at times.

There are two problems though

1. Disk performance particularly in the rotating rust world is
operations/second which is rarely related to volume

2. If the block layer is trying to decide whether the drive is busy
you've got it the wrong way up IMHO. Busy-ness is a property of the
device and often very device and subsystem specific, so the device end of
the chain should figure out how loaded it feels


Beyond that the entire problem is well understood and there isn't any
real difference between an IPv4 network and a storage layer. In fact in
some cases like NFS, DRBD, AoE, and remote block device stuff it's even
more so.

(TCP based remote block devices btw are a prime example of why you need
device end of chain figuring out busy state.. you'll otherwise end up
doing double backoff)

Alan

