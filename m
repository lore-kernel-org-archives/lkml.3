Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3HWSV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:21:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51410 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab3HWSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:21:25 -0400
X-Sasl-enc: SRB1eflVAM0iZAU2NkwcKGaw8nkJCBWMe98/g3ph60eh 1377282083
Date: Fri, 23 Aug 2013 11:21:21 -0700
From: Greg KH <greg@kroah.com>
To: Graham Williams <gwilli@broadcom.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH] usb: acm gadget: Null termintate strings table
Message-ID: <20130823182121.GA12543@kroah.com>
References: <063828A851006E448B735F1021E028962ACE72A6@SJEXCHMB09.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <063828A851006E448B735F1021E028962ACE72A6@SJEXCHMB09.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:51:12PM +0000, Graham Williams wrote:
> 
> The gadget strings table should be null terminated.
> usb_gadget_get_string() loops through the table
> expecting a null at the end of the list.
> 
> Signed-off-by: Graham Williams <gwilli@broadcom.com>

Nice, that works.

> ---
> drivers/usb/gadget/f_acm.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
> index 4b7e33e..ab1065a 100644
> --- a/drivers/usb/gadget/f_acm.c
> +++ b/drivers/usb/gadget/f_acm.c
> @@ -285,6 +285,7 @@ static struct usb_string acm_string_defs[] = {
>         [ACM_CTRL_IDX].s = "CDC Abstract Control Model (ACM)",
>         [ACM_DATA_IDX].s = "CDC ACM Data",
>         [ACM_IAD_IDX ].s = "CDC Serial",
> +       {  } /* end of list */

But this doesn't at all :(

Please fix your email client to not convert tabs to spaces.  Email the
patch to yourself and see if you can apply it properly first.  Also, the
kernel file, Documentation/email_clients.txt will help in setting things
up properly.

thanks,

greg k-h
