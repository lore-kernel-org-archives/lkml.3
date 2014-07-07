Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaGGSu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:50:28 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:49287 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750957AbaGGSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:50:25 -0400
Date: Mon, 7 Jul 2014 20:50:15 +0200
From: Josef Gajdusek <atx@atx.name>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net
Subject: Re: [PATCH 1/5] staging:iio:hmc5843: Added regmap support
Message-ID: <20140707185013.GA10383@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BAD22D.2010909@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 06:00:29PM +0100, Jonathan Cameron wrote:
> On 02/07/14 14:50, Josef Gajdusek wrote:
> > This patch changes hmc5843.c to use regmap. This provides transparent caching
> > to the code as well as abstraction necessary to add support for SPI-based
> > hmc5983.
> >
> > Signed-off-by: Josef Gajdusek <atx@atx.name>
> Hi Josef,
> 
> A few little bits and pieces inline.
> Peter, could you also take a look at this series?
> 
> Thanks,
> 
> Jonathan

Hello,

> Whilst minor, we do have a slight change in how this works in the
> event
> of an error.  I don't particularly mind it, but perhaps should have
> been broken out for separate discussion.

It could be changed to use _check version of the regmap function (all
other update_bits calls then probably should be changed as well). Though
that would double the amount of data sent and be of any use only on
defective chip.

> Why move these?  You now have the device going to sleep whilst
> the userspace interface is still available...

strange, I remember this causing issues. Now I am unable to
reproduce them so it was probably something else. Do you want me to
resend or can you apply without these lines swapped?
