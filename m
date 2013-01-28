Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3A1TuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:50:16 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51811 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3A1TuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:50:12 -0500
Date: Mon, 28 Jan 2013 20:49:58 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>, Matt Porter <mporter@ti.com>,
        Chase Maupin <chase.maupin@ti.com>, Jason Kridner <jdk@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
Message-ID: <20130128194958.GA6129@netboy.at.omicron.at>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
 <20130128182451.GC2445@netboy.at.omicron.at>
 <4E26978C-0B09-4E06-8373-49F1850C08C4@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E26978C-0B09-4E06-8373-49F1850C08C4@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 08:40:25PM +0200, Pantelis Antoniou wrote:
> Hi Richard,
> 
> Yes, I guess this was more of a drive-by patch dump - but people need this
> to get PG2.0 silicon to work on am33xx.

And what is PG2.0?

> And no, I don't think having a non-NAPI code path is backwards, especially
> when trying to debug hardware problems; the non-NAPI driver is much easier
> to understand and follow, especially when there is a convoluted method
> you have to follow to have the h/w acknowledge the interrupt.

Special debug modes are fine to have, but not in mainline code. 
I suggest taking a look at the recent netdev discussion on this.
Someone wanted to make napi/non-napi a DT option, and it got
nixed.

> Not every device can be conveniently be made to shut up so that NAPI processing 
> can take place at a later time.

So, are you saying that the cpsw cannot work as a napi device?
 
> The NAPI case is still broken in this driver, which OOPs under load.

And does your patch fix it, or not?

It would be nice to know what the problem is, and how to reproduce
it. I haven't seen any OOPs on the beaglebone, but maybe I am not
trying hard enough.

Thanks,
Richard
