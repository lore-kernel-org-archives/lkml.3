Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3LNU5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:57:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59267 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3LNU5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:57:05 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:56:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] drivers: reset: Mark function as static in core.c
Message-ID: <20131214205657.GQ17601@leaf>
References: <20131214132610.GA8691@rashika>
 <20131214141534.GD5443@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214141534.GD5443@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 05:15:34PM +0300, Dan Carpenter wrote:
> On Sat, Dec 14, 2013 at 06:56:10PM +0530, Rashika Kheria wrote:
> > This patch marks the function of_reset_simple_xlate() and
> > devm_reset_control_put() as static in core.c because it is not used
> > outside this file.
> > 
> > Thus, it also eliminate the following warnings in core.c:
> > drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
> > drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]
> > 
> 
> These are EXPORT_SYMBOL_GPL() so that doesn't make sense.
> devm_reset_control_put() is not used at all and of_reset_simple_xlate()
> doesn't look like it needs to be exported.  Philipp?

That sounds like the right fix to me: drop devm_reset_control_put and
its export completely, and drop the export of make
of_reset_simple_xlate.  Unless there's some relevant out-of-tree caller
of either function, that seems sensible.

- Josh Triplett
