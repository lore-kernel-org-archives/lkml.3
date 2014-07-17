Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaGQKoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbaGQKoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:44:09 -0400
Message-ID: <53C7A8C6.3010001@redhat.com>
Date: Thu, 17 Jul 2014 12:43:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Amit Virdi <amit.virdi@st.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        rdunlap@infradead.org, ming.lei@canonical.com,
        hsi-ss-sw-devel@lists.codex.cro.st.com
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
References: <5255a576a562f60c185e89b5937357290242fe1e.1405586653.git.amit.virdi@st.com>
In-Reply-To: <5255a576a562f60c185e89b5937357290242fe1e.1405586653.git.amit.virdi@st.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/17/2014 10:47 AM, Amit Virdi wrote:
> Section 4.4.7.2 of the USB3.0 spec says:
> 	A zero-length data payload is a valid transfer and may be useful for
> 	some implementations.
> 
> So, extend the logic of allowing URB_ZERO_PACKET to interrupt urbs too.
> Otherwise, the kernel throws error of BOGUS transfer flags.
> 
> Signed-off-by: Amit Virdi <amit.virdi@st.com>

Seems sensible to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/usb/core/urb.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
> index 991386c..a136246 100644
> --- a/drivers/usb/core/urb.c
> +++ b/drivers/usb/core/urb.c
> @@ -460,6 +460,10 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>  	case USB_ENDPOINT_XFER_CONTROL:
>  		allowed |= URB_NO_FSBR;	/* only affects UHCI */
>  		/* FALLTHROUGH */
> +	case USB_ENDPOINT_XFER_INT:
> +		if (is_out)
> +			allowed |= URB_ZERO_PACKET;
> +		/* FALLTHROUGH */
>  	default:			/* all non-iso endpoints */
>  		if (!is_out)
>  			allowed |= URB_SHORT_NOT_OK;
> 
