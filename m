Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaI1HLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 03:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaI1HLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 03:11:49 -0400
Date: Sun, 28 Sep 2014 09:09:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Nicholas Krause <yocto6@gmail.com>
Cc: IvDoorn@gmail.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] wireless: Remove unnessary write over of
 register 11 in rt2800lib.c
Message-ID: <20140928070923.GA2087@redhat.com>
References: <1411852301-26857-1-git-send-email-yocto6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411852301-26857-1-git-send-email-yocto6@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 05:11:41PM -0400, Nicholas Krause wrote:
> This removes the unnecessary  overwrite of register 11 in the function,
> rt2800_config_channel as we are already writing a correct value to the
> register with rt2800_rfcsr_write(rt2x00dev,11.rfcsr).
What make you sure that overwrite is unnecessary ?

> 
> Signed-off-by: Nicholas Krause <yocto6@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 893c9d5..fb0ae38 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2787,8 +2787,6 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
>  
>  	if (rf->channel <= 14) {
>  		rt2800_rfcsr_write(rt2x00dev, 10, 0x90);
> -		/* FIXME: RF11 owerwrite ? */
> -		rt2800_rfcsr_write(rt2x00dev, 11, 0x4A);
We need a prove that remove is correct, i.e. some reference to 
vendor code or spec that current writing register twice with
different values is wrong.

NACK for the patch.

Stanislaw
