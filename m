Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaHIHsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 03:48:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55287 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHIHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 03:48:43 -0400
Date: Sat, 9 Aug 2014 09:48:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        acab@digitalfuture.it, stable@kernel.org
Subject: Re: [PATCH] random: fix 32MB+ reads from /dev/urandom
Message-ID: <20140809074841.GB1467@amd.pavel.ucw.cz>
References: <20140723171421.GA2997@p183.telecom.by>
 <20140723202641.GF6673@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723202641.GF6673@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-23 16:26:41, Theodore Ts'o wrote:
> I don't think this patch is worthwhile.  There is no legitimate reason
> to be using such large reads like this, and read(2) is always allowed
> to return a short read (for example, if a signal comes in while the
> read is happening).  The only difference is that we are now guaranteed
> to return a short-read if you try to read more than 32MB.  Given

Regression from previous versions would be the reason. I'm pretty sure
someone has that dd in the scripts somewhere. (And signals are not an
issue in dd case.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
