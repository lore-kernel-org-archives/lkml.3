Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3I2Xlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:41:51 -0400
Received: from science.horizon.com ([71.41.210.146]:29854 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751720Ab3I2Xlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:41:49 -0400
Date: 29 Sep 2013 19:41:46 -0400
Message-ID: <20130929234146.31004.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rmallon@gmail.com
Subject: Re: [PATCH] printk: Check real user/group id for %pK
Cc: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <5248B724.8060408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, so the pppd application is actually doing the correct thing.

And a CAP_SYSLOG setuid binary that *doesn't* DTRT seems like a more
immediate security hole than leaking kernel addresses.  After all
kptr_restrict is optional precisely because the benefit is marginal.

The interesting question is what credentials make sense for %pK outside
of a seq_printf().  Does it even make sense in a generic printk?  In that
case, it's the permission of the syslogd that matters rather than the
process generating the message.

> Will wait and see what others have to say.

Me, too.  Dan in particular.
