Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaEHLf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:35:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25345 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaEHLf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:35:27 -0400
Date: Thu, 8 May 2014 14:35:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] staging: lirc: Fix sparse warnings
Message-ID: <20140508113506.GF26890@mwanda>
References: <1399547597-4006-1-git-send-email-tuomas.tynkkynen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399547597-4006-1-git-send-email-tuomas.tynkkynen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 02:13:17PM +0300, Tuomas Tynkkynen wrote:
> Fix sparse warnings by adding __user and __iomem annotations where
> necessary and removing certain unnecessary casts. While at it,
> also use u32 in place of __u32.
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

Thanks.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Btw, don't resend this (someone will have to fix it in a later patch)
but I notice that these IOCTLs are not implemented consistently.  Even
outside of staging we have this problem.  For example lirc_rx51_ioctl().

In this function the user gets a u32.

>  	case LIRC_GET_FEATURES:
> -		result = put_user(features, (__u32 *) arg);
> +		result = put_user(features, uptr);
>  		if (result)
>  			return result;
>  		break;

But here they get a long.

>  	case LIRC_GET_FEATURES:
> -		result = put_user(features, (unsigned long *) arg);
> +		result = put_user(features, uptr);
>  		break;

My feeling it should always be u32 so we don't have to write a
compatability layer for 32 bit applications on a 64 bit kernel.

regards,
dan carpenter

