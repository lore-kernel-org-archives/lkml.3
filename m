Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3GZHdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:33:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26698 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GZHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:33:10 -0400
Date: Fri, 26 Jul 2013 10:32:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, wonkang@gctsemi.com, joe@perches.com,
        devel@driverdev.osuosl.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] staging: gdm724x: use GFP_ATOMIC under spin lock
Message-ID: <20130726073233.GD5585@mwanda>
References: <CAPgLHd-WN2VF7vEjUn0uLd_RQYYF1qvUy1TUz4EmyPbi=8JQ4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-WN2VF7vEjUn0uLd_RQYYF1qvUy1TUz4EmyPbi=8JQ4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:15:55AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> A spin lock is taken here so we should use GFP_ATOMIC.
> 

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

But the locking here is really odd and pointless.  usb_submit_urb()
returns asynchronously before the data has been sent, so there is
almost no point in locking around it.

regards,
dan carpenter

