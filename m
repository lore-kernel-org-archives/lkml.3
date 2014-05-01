Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaEAKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:50:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaEAKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:50:48 -0400
Date: Thu, 1 May 2014 13:50:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, mcgrof@do-not-panic.com,
        gregkh@linuxfoundation.org, oat.elena@gmail.com,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8188eu: fix potential leak in
 rtw_set_key()
Message-ID: <20140501105025.GZ4963@mwanda>
References: <20140501123057.5f00e30d@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501123057.5f00e30d@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 12:30:57PM +0200, Christian Engelmayer wrote:
> Fix a potential leak in the error path of rtw_set_key(). In case the requested
> algorithm is not supported by the driver, the function returns without
> enqueuing or freeing the already allocated command and parameter structs. Use
> a centralized exit path and make sure that all memory is freed correctly.
> Detected by Coverity - CID 1077716, 1077717.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> v2: Added changes requested by Dan Carpenter:
> 
>    * Just return directly where no cleanup is needed.
>    * Prefer naming labels by the labeled action rather than the goto location.
> 
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

