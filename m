Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3HaLFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:05:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45111 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3HaLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:05:12 -0400
Date: Sat, 31 Aug 2013 14:04:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, Linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Devel <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] Staging:BCM:DDRInit.c:Renaming __FUNCTION__
Message-ID: <20130831110459.GT6329@mwanda>
References: <5220DB1C.5080700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5220DB1C.5080700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 06:49:16PM +0100, Paul McQuade wrote:
> >From c21d0da84c92d351f37b70c0d9c01a66fcb84e88 Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Thu, 15 Aug 2013 20:00:50 +0100
> Subject: [PATCH] Staging:BCM:DDRInit.c:Renaming __FUNCTION__
> 

Don't put these in the patch description.

> __Function__ gets renamed with __func__
> 

__FUNCTION__

You have some other changes as well like white space changes to
surrounding lines.  Put those in a separate patch.


>  				retval = wrmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
>  				if(retval < 0) {
> -					BCM_DEBUG_PRINT(Adapter,CMHOST, WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __FUNCTION__, __LINE__);
> +					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
>  					return retval;
>  				}

Here you changed the WRM to RDM.  That can fall under the trivial and
closely related change but it needs to be mentioned in the changelog.
Except in this case the original message was correct and the new message
is wrong.  W stands for "write" and R stands for "read".

regards,
dan carpenter

