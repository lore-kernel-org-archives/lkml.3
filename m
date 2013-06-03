Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3FCJ5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:57:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37714 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FCJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:57:21 -0400
Date: Mon, 3 Jun 2013 12:57:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/8] pktcdvd: Convert printk to pr_<level>
Message-ID: <20130603095714.GA23987@mwanda>
References: <1369978679.10556.36.camel@joe-AO722>
 <cover.1370048648.git.joe@perches.com>
 <92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 09:11:23PM -0700, Joe Perches wrote:
> +static const char *sense_key_string(__u8 index)
> +{
> +	static const char *info[9] = {
> +		"No sense", "Recovered error", "Not ready",
> +		"Medium error", "Hardware error", "Illegal request",
> +		"Unit attention", "Data protect", "Blank check"
> +	};
> +	if (index < 8)

Off by one:

	if (index < 9)


> +		return info[index];
> +	return "INVALID";

regards,
dan carpenter

