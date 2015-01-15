Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbbAOVdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:33:54 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:63138 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbbAOVdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:33:52 -0500
Message-ID: <54B8323D.6020304@gmail.com>
Date: Thu, 15 Jan 2015 22:33:49 +0100
From: "christophe.ricard" <christophe.ricard@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Anda-Maria Nicolae <anda-maria.nicolae@intel.com>,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] NFC: st21nfcb: Avoid use of skb after free
References: <1421317857-1713-1-git-send-email-anda-maria.nicolae@intel.com>
In-Reply-To: <1421317857-1713-1-git-send-email-anda-maria.nicolae@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anda-Maria,

I agree with your fix. I have built and tested it successfully.
I will include it in a new patch series with a:
Acked-by: Christophe Ricard <christophe-h.ricard@st.com>

Thanks a lot.
Christophe
On 15/01/2015 11:30, Anda-Maria Nicolae wrote:
> Do not insert in send queue the skb that contains unknown Packet Control Byte
>
> Signed-off-by: Anda-Maria Nicolae <anda-maria.nicolae@intel.com>
> ---
> Only compile tested, please have a look
>
>   drivers/nfc/st21nfcb/ndlc.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/st21nfcb/ndlc.c b/drivers/nfc/st21nfcb/ndlc.c
> index bac50e8..72659a3 100644
> --- a/drivers/nfc/st21nfcb/ndlc.c
> +++ b/drivers/nfc/st21nfcb/ndlc.c
> @@ -138,7 +138,7 @@ static void llt_ndlc_requeue_data_pending(struct llt_ndlc *ndlc)
>   		default:
>   			pr_err("UNKNOWN Packet Control Byte=%d\n", pcb);
>   			kfree_skb(skb);
> -			break;
> +			continue;
>   		}
>   		skb_queue_head(&ndlc->send_q, skb);
>   	}

