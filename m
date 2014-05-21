Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaEUT1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:27:36 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56483 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEUT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:27:34 -0400
Message-ID: <537CFE29.7050100@cogentembedded.com>
Date: Wed, 21 May 2014 23:27:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>,
        isdn@linux-pingi.de
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mISDN: Use time_before()
References: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/21/2014 11:10 PM, Manuel Schölling wrote:

> To be future-proof and for better readability the time comparisons are modified
> to use time_before() instead of plain, error-prone math.

> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>   drivers/isdn/mISDN/l1oip_core.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
> index 2c0d2c2..1c2bc36 100644
> --- a/drivers/isdn/mISDN/l1oip_core.c
> +++ b/drivers/isdn/mISDN/l1oip_core.c
> @@ -287,7 +287,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
>   	p = frame;
>
>   	/* restart timer */
> -	if ((int)(hc->keep_tl.expires-jiffies) < 5 * HZ) {
> +	if (time_before(hc->keep_tl.expires - 5 * HZ, jiffies)) {

    Wouldn't it be clearer this way:

	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ)) {

>   		del_timer(&hc->keep_tl);
>   		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
>   		add_timer(&hc->keep_tl);
> @@ -621,7 +621,8 @@ multiframe:
>   		goto multiframe;
>
>   	/* restart timer */
> -	if ((int)(hc->timeout_tl.expires-jiffies) < 5 * HZ || !hc->timeout_on) {
> +	if (time_before(hc->timeout_tl.expires - 5 * HZ, jiffies)
> +	    || !hc->timeout_on) {

    Please leave || on the previous line.

WBR, Sergei

