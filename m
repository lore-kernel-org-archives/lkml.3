Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3EGJlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:41:37 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40498 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3EGJlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:41:35 -0400
Date: Tue, 7 May 2013 10:36:02 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Pavel Machek <pavel@denx.de>
Cc: Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net, arnd@arndb.de,
        johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130507093602.GA30902@page>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <20130426124128.GB6946@page>
 <20130426213723.GA24891@amd.pavel.ucw.cz>
 <20130426214313.GB24891@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426214313.GB24891@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Apologies for the delay, but this looks good to me.

On Fri, Apr 26, 2013 at 11:43:14PM +0200, Pavel Machek wrote:
> It seems we made a mistake when creating dw_apb_timer_of.c:
> picoxcell sched_clock had parts that were not related to
> dw_apb_timer, yet we moved them to dw_apb_timer_of, and tried to
> use them on socfpga.
> 
> This results in system where user/system time is not measured
> properly, as demonstrated by
>     
>     time dd if=/dev/urandom of=/dev/zero bs=100000 count=100
>     
> So this patch switches sched_clock to hardware that exists on both
> platforms, and adds missing of_node_put() in dw_apb_timer_init().
>     
> Signed-off-by: Pavel Machek <pavel@denx.de>

Acked-by: Jamie Iles <jamie@jamieiles.com>
