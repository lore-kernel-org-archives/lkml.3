Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3EMIvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:51:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3EMIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:51:53 -0400
Date: Mon, 13 May 2013 11:51:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, gmate.amit@gmail.com,
        devel@driverdev.osuosl.org, manohar.vanga@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yamanetoshi@gmail.com, yongjun_wei@trendmicro.com.cn, joe@perches.com
Subject: Re: [PATCH] staging: vme: fix error return code in vme_user_probe()
Message-ID: <20130513085132.GI1360@mwanda>
References: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com>
 <5190A140.3020306@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5190A140.3020306@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 09:16:00AM +0100, Martyn Welch wrote:
> On 13/05/13 07:05, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Fix to return -ENOMEM in the resource alloc error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> 
> Hi Wei,
> 
> Thanks for your patch. As this is resource allocation rather than memory
> allocation that is failing, would -EAGAIN not make more sense than -ENOMEM?
> 

ENOMEM is better.  EAGAIN is for when trylock() fails etc.  In other
words we are not allowed to block and someone is using the lock we
need.

It feels like we discuss error codes a lot on LKML and they should
be documented under Documententation/.  The closest thing is
Documentation/i2c/fault-codes.

regards,
dan carpenter
