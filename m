Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3HMOkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:40:07 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53550 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3HMOje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:39:34 -0400
Message-ID: <520A4528.6020609@cogentembedded.com>
Date: Tue, 13 Aug 2013 18:39:36 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hayes Wang <hayeswang@realtek.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net/usb/r8152: enable tx checksum
References: <1376378913-879-1-git-send-email-hayeswang@realtek.com> <1376378913-879-2-git-send-email-hayeswang@realtek.com>
In-Reply-To: <1376378913-879-2-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/13/2013 11:28 AM, Hayes Wang wrote:

> Enable tx checksum.

> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>   drivers/net/usb/r8152.c | 63 +++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 58 insertions(+), 5 deletions(-)

> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c6c5aa2..5d9d949 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> @@ -964,6 +971,51 @@ err1:
>   	return -ENOMEM;
>   }
>
> +static void
> +r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc, struct sk_buff *skb)
> +{
[...]
> +		if (ip_protocol == IPPROTO_TCP) {
> +			opts2 |= TCP_CS;
> +			opts2 |= (skb_transport_offset(skb) & 0x7fff) << 17;
> +		} else if (ip_protocol == IPPROTO_UDP) {
> +			opts2 |= UDP_CS;
> +		} else
> +			WARN_ON_ONCE(1);

    Stange, why *else if* branch has {} and *else* don't. It should, according 
to Documentation/CodingStyle.

> +
> +		desc->opts2 = cpu_to_le32(opts2);
> +	}
> +}
> +

WBR, Sergei

