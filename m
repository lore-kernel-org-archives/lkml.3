Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077Ab3DJT5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:57:10 -0400
Received: from mx1.unsolicited.net ([173.255.193.191]:33308 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935117Ab3DJT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:57:08 -0400
Message-ID: <5165C412.3010302@unsolicited.net>
Date: Wed, 10 Apr 2013 20:57:06 +0100
From: David R <david@unsolicited.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: AMD Vi error and lost networking with r8169
References: <51616695.7080305@unsolicited.net> <20130407215303.GA28778@electric-eye.fr.zoreil.com>
In-Reply-To: <20130407215303.GA28778@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is working fine so far - no further hangs, and networking seems
much faster into the bargain. Will report back if it happens again.

Thanks
David

On 07/04/13 22:53, Francois Romieu wrote:
> David R <david@unsolicited.net> :
>> I'm been seeing some problems with my new ish AMD motherboard/processor
>> combo and networking (r8169). I see the following page fault :-
>>
>> Apr  7 12:25:14 david kernel: [156421.436545] AMD-Vi: Event logged
>> [IO_PAGE_FAULT device=02:00.0 domain=0x0015 address=0x0000000000003000
>> flags=0x0050]
> Can you give the hack below a try ?
>
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 28fb50a..ed8625d 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -4125,6 +4125,8 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
>  	case RTL_GIGA_MAC_VER_23:
>  	case RTL_GIGA_MAC_VER_24:
>  	case RTL_GIGA_MAC_VER_34:
> +	case RTL_GIGA_MAC_VER_35:
> +	case RTL_GIGA_MAC_VER_36:
>  		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
>  		break;
>  	default:

