Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3FQVYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:24:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3FQVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:24:44 -0400
Date: Tue, 18 Jun 2013 00:23:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/4 v2] silicom: checkpatch: assignments in if conditions
Message-ID: <20130617212320.GN5008@mwanda>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
 <1371496539-25461-1-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371496539-25461-1-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 09:15:39PM +0200, Lorenz Haspel wrote:
> Fixes checkpatch error:
> There were assignments in if conditions, so I extracted them.
> 
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
> ---
> v2: removed some buggy extra lines and fixed white space issues

Gar....  This isn't right either.  Now it has *too many* blank
lines.  It's only between declarations and code that I was
complaining about.  You've added them between assignments and error
checks.


> @@ -1224,7 +1237,9 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
>  		return -1;
>  #endif
>  	if (pbpctl_dev->bp_10g9) {
> -		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
> +		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
> +

This blank line is harmful.

> +		if (!pbpctl_dev_c)
>  			return -1;
>  	}
>  
> @@ -1742,9 +1757,9 @@ static void write_data_port_int(bpctl_dev_t *pbpctl_dev,
>  
>  static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
>  {
> -	bpctl_dev_t *pbpctl_dev_b = NULL;
> +	bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
>  

This blank line is required.

So what you have here is fine, but if you wanted you could re-write
this like:
{
	bpctl_dev_t *pbpctl_dev_b;

	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
	if (!pbpctl_dev_b)
		return -1;

Generally, you shouldn't put anything complicated in the initializer
statement.  People don't read that code as thouroughly and
initializers are sometimes a source of bugs.  But what you have here
is also perfectly acceptable.

> -	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
> +	if (!pbpctl_dev_b)
>  		return -1;
>  	atomic_set(&pbpctl_dev->wdt_busy, 1);
>  	write_data_port_int(pbpctl_dev, value & 0x3);

rergards,
dan carpenter
