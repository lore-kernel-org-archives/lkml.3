Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaI1Dbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:31:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60505 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaI1Dbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:31:32 -0400
Message-ID: <5427810F.2000305@infradead.org>
Date: Sat, 27 Sep 2014 20:31:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Nicholas Krause <yocto6@gmail.com>, linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Remove read of issue in sa1111.c in sa1111_resume
References: <1411872652-16207-1-git-send-email-yocto6@gmail.com>
In-Reply-To: <1411872652-16207-1-git-send-email-yocto6@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/14 19:50, Nicholas Krause wrote:
> This removes the FIXME message and issue with reading in this driver before resuming
> in the function, sa1111_resume.

You need to explain why this makes any sense.
Hint:  it doesn't.

> Signed-off-by: Nicholas Krause <yocto6@gmail.com>
> ---
>  arch/arm/common/sa1111.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index e57d7e5..0c4b9a9 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -950,9 +950,7 @@ static int sa1111_resume(struct platform_device *dev)
>  
>  	/*
>  	 * Ensure that the SA1111 is still here.
> -	 * FIXME: shouldn't do this here.
>  	 */
> -	id = sa1111_readl(sachip->base + SA1111_SKID);
>  	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
>  		__sa1111_remove(sachip);
>  		platform_set_drvdata(dev, NULL);
> 


-- 
~Randy
