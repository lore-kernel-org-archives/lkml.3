Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaFBLm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:42:26 -0400
Received: from b.mx.filmlight.ltd.uk ([77.107.81.251]:38414 "HELO
	b.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753101AbaFBLmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:42:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2014 07:42:23 EDT
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Roger Willcocks <roger@filmlight.ltd.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org,
        john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-fsdevel@vger.kernel.org, geert@linux-m68k.org,
        tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com
In-Reply-To: <20140602002822.GQ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	 <5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
	 <5507340.nVBP5LFtqn@wuerfel> <20140601002437.GL14410@dastard>
	 <20140602002822.GQ14410@dastard>
Content-Type: text/plain
Date: Mon, 02 Jun 2014 12:35:41 +0100
Message-Id: <1401708941.6065.51.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2014-06-02 at 10:28 +1000, Dave Chinner wrote:

> 
> The 32 bit second counters in timestamps are too small to represent
> time beyond the unix epoch (jan 2038) correctly. Extend the on-disk
> format for a timestamp to include an 8-bit epoch counter so that we
> can extend time for up to 255 Unix epochs. This should be good for
> representing timestamps from 1970 to somewhere around 19,000 A.D....
> 

I assume you're using an 'epoch' variable and not simply using the
padding byte as an eight-bit prefix to the existing 32-bit counter
because the existing counter is signed ?

For long term sanity it might make more sense for the eight-bit value to
be a simple (sign-extended) prefix from 1970.

So if the feature bit is set it's a 40-bit signed time, which is good
for 1970 +/- 17400 years or so.

--
Roger





