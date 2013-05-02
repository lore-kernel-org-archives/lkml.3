Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940Ab3EBOKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:10:13 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56071 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3EBOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:10:10 -0400
Date: Thu, 2 May 2013 07:10:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        chf.fritz@googlemail.com, mkl@pengutronix.de
Subject: Re: [stable 3.0] ppc build breakage [was: Linux 3.0.75]
Message-ID: <20130502141000.GB24348@kroah.com>
References: <20130426043017.GA22553@kroah.com>
 <518263F7.70204@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518263F7.70204@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 03:02:47PM +0200, Jiri Slaby wrote:
> On 04/26/2013 06:30 AM, Greg KH wrote:
> > Christoph Fritz (1): can: sja1000: fix handling on dt properties on
> > little endian systems
> 
> Hi, this one breaks ppc builds:
> drivers/net/can/sja1000/sja1000_of_platform.c: In function
> 'sja1000_ofp_probe':
> drivers/net/can/sja1000/sja1000_of_platform.c:138: error: implicit
> declaration of function 'of_property_read_u32'
> drivers/net/can/sja1000/sja1000_of_platform.c:168: error: implicit
> declaration of function 'of_property_read_bool'
> 
> 
> They depend on:
> commit a3b853633d78c3930b513ee219df48637ac82eed
> Author: Thomas Abraham <thomas.abraham@linaro.org>
> Date:   Thu Jun 30 21:26:10 2011 +0530
> 
>     dt: add helper functions to read u32 and string property values
> ==== and ====
> commit fa4d34ccd0914ac87336ea2c17e9370dfecef286
> Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Date:   Tue Feb 7 12:12:51 2012 +0800
> 
>     of: introduce helper to manage boolean
> 
> 
> but neither of those is in 3.0...

So I should revert the original patch here, I'll do that for the next
release, thanks.

greg k-h
