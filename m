Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3BPVbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:31:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45447 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3BPVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:31:42 -0500
Date: Sat, 16 Feb 2013 13:27:57 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] generic-adc-battery: forever loop in gab_remove()
Message-ID: <20130216212757.GB1741@lizard.sbx05280.losalca.wayport.net>
References: <20130214072643.GA4690@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130214072643.GA4690@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:26:43AM +0300, Dan Carpenter wrote:
> There is a forever loop calling iio_channel_release() because the
> "chan < " part of the "chan < ARRAY_SIZE()" is missing.  This is in both
> the error handling on probe and also in the remove function.
> 
> The other thing is that it's possible for some of the elements of the
> adc_bat->channel[chan] array to be an ERR_PTR().  I've changed them to
> be NULL instead.  We're still not allowed to pass NULLs to
> iio_channel_release() so I've added a check.
> 
> Finally, I removed an unused "chan = ARRAY_SIZE(gab_chan_name);"
> statement as a small cleanup.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks a lot!

Anton
