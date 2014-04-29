Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaD2Kfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:35:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbaD2Kfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:35:47 -0400
Date: Tue, 29 Apr 2014 13:35:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        James Simmons <uja.ornl@gmail.com>, Li Xi <lixi@ddn.com>
Subject: Re: [PATCH 34/47] staging/lustre/libcfs: add CPU table functions for
 uniprocessor
Message-ID: <20140429103527.GB26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-35-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-35-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:58PM -0400, Oleg Drokin wrote:
>  int
> +cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len)
> +{
> +	int	rc = 0;

GCC has a feature where it warns about unitialized variables.  If you do
bogus it disables this safety feature.  Also the bogus assignment is
confusing for people trying to read the code.

> +
> +	rc = snprintf(buf, len, "%d\t: %d\n", 0, 0);
> +	len -= rc;
> +	if (len <= 0)
> +		return -EFBIG;

It would be more clear to say:

	rc = snprintf(buf, len, "%d\t: %d\n", 0, 0);
	if (rc >= len)
		return -EFBIG;

	return rc;

regards,
dan carpenter

> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(cfs_cpt_table_print);
> +

