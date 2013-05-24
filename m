Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3EXOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:46:42 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41327 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3EXOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:46:41 -0400
Message-ID: <519F7D56.8080900@cogentembedded.com>
Date: Fri, 24 May 2013 18:46:46 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Federico Manzan <f.manzan@gmail.com>
CC: gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbfs: Increase arbitrary limit for USB 3 isopkt length
References: <1369385249-15624-1-git-send-email-f.manzan@gmail.com>
In-Reply-To: <1369385249-15624-1-git-send-email-f.manzan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-05-2013 12:47, Federico Manzan wrote:

> Increase the current arbitrary limit for isocronous packet size to a
> value large enough to account for USB 3.0 super bandwidth streams,
> bMaxBurst (0~15 allowed, 1~16 packets)
> bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
> so the size max for one USB 3 isocronous transfer is
> 1024 byte * 16 * 3 = 49152 byte

> Signed-off-by: Federico Manzan <f.manzan@gmail.com>
> ---
>   drivers/usb/core/devio.c |    8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index caefc80..7ac137e 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1287,9 +1287,11 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>   			goto error;
>   		}
>   		for (totlen = u = 0; u < uurb->number_of_packets; u++) {
> -			/* arbitrary limit,
> -			 * sufficient for USB 2.0 high-bandwidth iso */
> -			if (isopkt[u].length > 8192) {
> +			/* arbitrary limit need for USB 3.0
> +			 * bMaxBurst (0~15 allowed, 1~16 packets)
> +			 * bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
> +			 * sizemax: 1024 * 16 * 3 = 49152*/

    The preferred style of the multi-line comments is this:

/*
  * bla
  * bla
  */

WBR, Sergei

