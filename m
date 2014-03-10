Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaCJNyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:54:11 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42824 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaCJNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:54:09 -0400
Date: Mon, 10 Mar 2014 14:54:03 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: stefan.sorensen@spectralink.com, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] dp83640: Get pin and master/slave configuration
 from DT
Message-ID: <20140310135402.GC19781@netboy>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
 <20140213.173957.2126489785330496380.davem@davemloft.net>
 <20140214090601.GA3906@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214090601.GA3906@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:06:01AM +0100, Richard Cochran wrote:
> On Thu, Feb 13, 2014 at 05:39:57PM -0500, David Miller wrote:
> > If you don't like it, be angry at whoever added this module parameter
> > in the first place, not me.  Module parameters are 99 times out of 100
> > not the right way to configure something, really.
> 
> Yeah, I am the one, be angry with me.

Look back at this driver, there was in fact a good reason to have at
least the "calibration" pin as a module parameter. When using multiple
phyters, together they should act as one clock. The driver does this
automatically during the probe method, and so it needs to know which
pin to use well before user space is ready.

However, the other pin functions could have waited for user space
configuration, but I had just lumped them all together. Going forward,
I think the get/setpin ioctl will work fine both for this driver
(without changing the legacy module parameters) and for future ones.

Thanks,
Richard
