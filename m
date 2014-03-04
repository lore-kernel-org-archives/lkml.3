Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaCDJEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:04:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34348 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbaCDJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:04:38 -0500
Date: Tue, 4 Mar 2014 12:04:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        ying.xue@windriver.com, davem@davemloft.net
Subject: Re: [PATCH 4/7] staging: cxt1e1: fix checkpatch error 'assignment in
 if condition'
Message-ID: <20140304090419.GT26722@mwanda>
References: <1905523.1xUMUtkBrU@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1905523.1xUMUtkBrU@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:09:39AM +0900, Daeseok Youn wrote:
> @@ -1174,7 +1179,8 @@ cleanup_hdlc(void)
>  			ci = (ci_t *)(netdev_priv(hi->ndev));
>  			for (j = 0; j < ci->max_port; j++)
>  				for (k = 0; k < MUSYCC_NCHANS; k++)
> -					if ((ndev = ci->port[j].chan[k]->user))
> +					ndev = ci->port[j].chan[k]->user;
> +					if (ndev)
>  					{
>  						do_deluser(ndev, 0);
>  					}


This patch introduces a bug here because the inner for loop now has two
statement but no curly braces.

regards,
dan carpenter
