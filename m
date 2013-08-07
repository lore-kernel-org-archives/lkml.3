Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3HGUyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:54:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51988 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:53:59 -0400
Date: Wed, 7 Aug 2013 13:53:57 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: PREEMPT_RT vs bcache
Message-ID: <20130807205357.GD11612@kmo-pixel>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:28:18PM +0200, Ben Hutchings wrote:
> As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
> {down,up}_read_non_owner().  But these are not implemented by the -rt
> patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
> there a fundamental conflict here?

You should be able to cherry pick
84759c6d18c5144432781ddca037d929ee9db8a5 (Revert "rw_semaphore: remove
up/down_read_non_owner") - that went in when bcache was merged.
