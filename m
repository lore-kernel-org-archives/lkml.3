Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3FDLST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:18:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21299 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3FDLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:18:18 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130604111640.GE23987@mwanda>
Date: Tue, 4 Jun 2013 04:16:41 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>
Subject: Re: [patch] cciss: info leak in cciss_ioctl32_passthru()
References: <alpine.LFD.2.03.1306041602160.7145@erqung.pbz>
In-Reply-To: <alpine.LFD.2.03.1306041602160.7145@erqung.pbz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 04:09:10PM +0530, P J P wrote:
>    Hello Dan,
> ===
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 6374dc1..34971aa 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1201,6 +1201,7 @@ static int cciss_ioctl32_passthru(struct
> block_device *bdev, fmode_t mode,
>  	int err;
>  	u32 cp;
> 
> +	memset(&arg64, 0, sizeof(arg64));
> 	...
> ===
> 
>   This exact same patch was included back in 2010 by Mr Vasiliy Kulikov.
> 
>  -> https://git.kernel.org/linus/7ab5118d7c2be650bc936894f159dc1c597badae
> 
> But there is no entry/log of its reversal. Any idea why was it removed?

No no.  Vasily patched cciss_ioctl32_big_passthru() and this patch
changes cciss_ioctl32_passthru().

regards,
dan carpenter

