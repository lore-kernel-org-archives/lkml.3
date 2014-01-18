Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaARKGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 05:06:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35446 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaARKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 05:06:08 -0500
Date: Sat, 18 Jan 2014 13:05:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        bergwolf@gmail.com, jinshan.xiong@intel.com, oleg.drokin@intel.com,
        jacques-charles.lafoucriere@cea.fr, devel@driverdev.osuosl.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Message-ID: <20140118100547.GS7444@mwanda>
References: <52DA4E6A.1000308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DA4E6A.1000308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 05:50:34PM +0800, Chen Gang wrote:
> Unfortunately, not all compilers assumes the structures within a pack
> region also need be packed (e.g. metag), so need add a pack explicitly
> to satisfy all compilers.
> 
> The related error (under metag with allmodconfig):
> 
>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
> 
> And originally, all related code used "__attribute__((packed))", so
> still use it instead of '__packed'.

Use __packed.  Then at least one line will be correct which is better
than nothing.

regards,
dan carpenter

