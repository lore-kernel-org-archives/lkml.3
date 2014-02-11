Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaBKQp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:45:29 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:34872 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBKQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:45:27 -0500
Date: Tue, 11 Feb 2014 10:45:13 -0600
From: David Fries <David@Fries.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: small type cleanup in sysfs
Message-ID: <20140211164513.GF5530@spacedout.fries.net>
References: <20140211160826.GD9406@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211160826.GD9406@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 11 Feb 2014 10:45:14 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

I have some other changes in work, how automated is your checkers?
How much work is it for me to give a github repository and branch and
find out if I introduced any problems before submitting them?


I didn't get how you could get a less than one after a check for less
than one from the description or patch until I looked at the rest of
the source code.  Looks good if the description mentions
max_slave_count is an int.

How about wording it,

On 64 bit systems, a large value for "long tmp" is truncated when
assigning to "int md->max_slave_count" so we still end up with a value
less than one despite the "tmp < 1" check.

Acked-by: David Fries <david@fries.net>

On Tue, Feb 11, 2014 at 07:08:26PM +0300, Dan Carpenter wrote:
> On 64 bit systems, a large value for "tmp" could be truncated so we
> still end up with a ->max_slave_count which is less than one despite the
> "tmp < 1" check.
> 
> This is more of a problem for static checkers than a real life issue,
> but it's simple enough to fix.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index 9eb816b2ea5e..b96f61b15dc6 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -320,10 +320,10 @@ static ssize_t w1_master_attribute_show_timeout(struct device *dev, struct devic
>  static ssize_t w1_master_attribute_store_max_slave_count(struct device *dev,
>  	struct device_attribute *attr, const char *buf, size_t count)
>  {
> -	long tmp;
> +	int tmp;
>  	struct w1_master *md = dev_to_w1_master(dev);
>  
> -	if (kstrtol(buf, 0, &tmp) == -EINVAL || tmp < 1)
> +	if (kstrtoint(buf, 0, &tmp) == -EINVAL || tmp < 1)
>  		return -EINVAL;
>  
>  	mutex_lock(&md->mutex);

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
