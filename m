Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaJHVtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:49:42 -0400
Received: from relay08.alfahosting-server.de ([109.237.142.245]:33124 "EHLO
	relay08.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722AbaJHVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:49:40 -0400
X-Spam-DCC: : 
Date: Wed, 8 Oct 2014 23:49:27 +0200
From: Richard Leitner <me@g0hl1n.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: Re: [PATCH] input: avoid negative input device numbers
Message-ID: <20141008234927.5c4b8492@frodo>
In-Reply-To: <20141008213051.GD15198@dtor-ws>
References: <20141008224245.601a1339@frodo>
	<20141008212538.GB15198@dtor-ws>
	<20141008213051.GD15198@dtor-ws>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19486/Wed Oct  8 18:37:03 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014 14:30:51 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Wed, Oct 08, 2014 at 02:25:38PM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 08, 2014 at 10:42:45PM +0200, Richard Leitner wrote:
> > > From: Richard Leitner <richard.leitner@skidata.com>
> > > 
> > > Fix the format string for input device name generation to avoid
> > > negative device numbers when the id exceeds the maximum signed
> > > integer value.
> > 
> > Well, it is going to take us a while to get there :)
> > 
> > Applied, thank you.
> 
> By the way, we have similar issue in serio and gameport code, mind
> sending fixes for them as well?
> 
I'll send a patch for the serio in a few minutes.

The gameport code looks fine to me:

536		dev_set_name(&gameport->dev, "gameport%lu",
537				(unsigned long)atomic_inc_return(&gameport_no) - 1);

regards,
richard

