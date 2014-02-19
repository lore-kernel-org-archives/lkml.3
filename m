Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaBSTRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:17:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaBSTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:17:35 -0500
Date: Wed, 19 Feb 2014 19:17:17 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Grant Edwards <grant.b.edwards@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140219191717.486ac4d0@alan.etchedpixels.co.uk>
In-Reply-To: <5304EC33.5040502@hurleysoftware.com>
References: <20140218093829.GC1741@redhat.com>
	<5303DABD.9000302@hurleysoftware.com>
	<20140219130308.GC1851@redhat.com>
	<le2nmd$p1$1@ger.gmane.org>
	<5304EC33.5040502@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How can the requirement be for both must-handle-in-minimum-time data
> (low_latency) and the-userspace-reader-isn't-reading-fast-enough-
> so-its-ok-to-halt-transmission ?

Because low latency is about *turn around* time. There are plenty of
protocols that can flow control, do flow control and want low latency
because they are not windowed. It's not mutually exclusive by any means.

> But first I'd like some hard data on whether or not a low latency
> mode is even necessary (at least for user-space).

The easy way to simulate the annoying as crap worst cases from dumbass
firmware downloaders and the like is to set up a link between two PCs and
time 2000+ repetitions of

send 64 bytes
wait for a Y
send 64 bytes
wait for a Y
....

and the matching far end being a box running an existing kernel or a PIC
or something doing the responses.

Historically we used to lose about 20mS per cycle which over 2000 got to
be a bit of a PITA.

Low latency goes back to the days of flip buffers, bottom halves an a
100Hz clock. There are certainly better ways to do it now if its needed.

Alan

