Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3AUVpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:45:50 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:58721 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AUVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:45:48 -0500
Message-ID: <50FDB6FE.7010601@mvista.com>
Date: Tue, 22 Jan 2013 01:45:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] drivers/usb/musb/omap2430.c: adjust duplicate test
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr> <1358773378-4700-14-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1358773378-4700-14-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-01-2013 17:02, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Delete successive tests to the same location.  Data is the just previously
> allocated and tested value.  Test the result of the allocation made here
> instead.

> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@

> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>   { ... when forall
>     return ...; }
> ... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
>      when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>   { ... when forall
>     return ...; }
> // </smpl>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> The previous code could be further simplified by removing the
> initializations of ret to -ENOMEM, as is absent in this case.  But that is
> probably for another patch.

    I've already sent such patch and Felipe has queued it.

>   drivers/usb/musb/omap2430.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index da00af4..533c4fd 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -545,7 +545,7 @@ static int omap2430_probe(struct platform_device *pdev)
>   		}
>
>   		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
> -		if (!data) {
> +		if (!config) {

    Same about this change. You're a bit late this time. :-)

WBR, Sergei

