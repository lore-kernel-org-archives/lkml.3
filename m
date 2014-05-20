Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaETUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:03:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59562 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaETUDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:03:49 -0400
Date: Tue, 20 May 2014 13:03:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2] hwmon: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140520200336.GA11723@roeck-us.net>
References: <20140520181536.GA11483@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520181536.GA11483@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:45:37PM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also, the unnecessary label out_free is removed.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Applied to -next, just for the sake of it, but frankly that driver
is screwed up so badly that it is pretty much unusable anyway.
Almost all of its attributes are non-standard, and for most of them
that is completely unnecsssary.

Maybe we should create a to-be-removed list and put it there
as first candidate.

Guenter
