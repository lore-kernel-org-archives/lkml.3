Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3K1EHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:07:46 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43875 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab3K1EHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:07:44 -0500
Date: Wed, 27 Nov 2013 20:07:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: floe@butterbrot.org, rydberg@euromail.se,
        David Herrmann <dh.herrmann@gmail.com>, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] drivers: input: touchscreen: sur40: use static variable
 instead of stack varialbe for 'packet_id'
Message-ID: <20131128040741.GD15452@core.coreip.homeip.net>
References: <528AD6B3.1060507@gmail.com>
 <20131125011908.GA18921@codeaurora.org>
 <529555C5.7030404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529555C5.7030404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Wed, Nov 27, 2013 at 10:15:33AM +0800, Chen Gang wrote:
> 'packet_id' is used for checking sequence whether in order, it need be
> static variable independent from sur40_poll().
> 
> The related warning (with allmodconfig under hexagon):
> 
>   drivers/input/touchscreen/sur40.c: In function 'sur40_poll':
>   drivers/input/touchscreen/sur40.c:297:6: warning: 'packet_id' may be used uninitialized in this function [-Wuninitialized]
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/input/touchscreen/sur40.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index cfd1b7e..5dfd01a 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -251,7 +251,7 @@ static void sur40_poll(struct input_polled_dev *polldev)
>  	struct sur40_state *sur40 = polldev->private;
>  	struct input_dev *input = polldev->input;
>  	int result, bulk_read, need_blobs, packet_blobs, i;
> -	u32 packet_id;
> +	static u32 packet_id;

It is usually not a good idea to use statics in device drivers as it
does not work well when you have several devices of the same type
present in a system. Also, we process all blobs in one pass so there is
no need to preserve value of packet_id between calls to sur40_poll().

Thanks.

-- 
Dmitry
