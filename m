Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CFJ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:27:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:27:12 -0500
Date: Wed, 6 Mar 2013 12:26:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, kbuild@01.org
Subject: Re: [PATCH] iio: adc: exynos5_adc: fix compilation warnings
Message-ID: <20130306092643.GA9245@mwanda>
References: <1362543092-6446-1-git-send-email-ch.naveen@samsung.com>
 <513701FF.3000805@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513701FF.3000805@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:44:47AM +0100, Lars-Peter Clausen wrote:
> On 03/06/2013 05:11 AM, Naveen Krishna Chatradhi wrote:
> > From: Naveen Krishna Ch <ch.naveen@samsung.com>
> > 
> > Fixes the compilation warnings and potential NULL pointer
> > dereferencing pointed out by "Dan Carpenter".
> > 
> 
> I'd say that's a rather un-potential NULL pointer dereferencing, but if it
> makes the static checkers happy, why not. Since the same match table is used to
> match the device, probe won't be called unless there is a match, so
> of_match_node() will never return NULL in this case.
> 

Actually the reason Smatch complains is because this was built with
CONFIG_OF=n.  Probably it should depend on that in the Kconfig file?

The static checker warnings are a semi automatic thing and we only
send the one email and then mark them as looked at.  It's not worth
silencing false positives unless it makes the code easier to
audit.

regards,
dan carpenter

