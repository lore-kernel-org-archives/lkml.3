Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbbAIEEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:04:40 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34744 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbbAIEEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:04:38 -0500
MIME-Version: 1.0
In-Reply-To: <1420775239-24745-1-git-send-email-gigi.joseph@ti.com>
References: <1420775239-24745-1-git-send-email-gigi.joseph@ti.com>
Date: Fri, 9 Jan 2015 09:34:36 +0530
Message-ID: <CAEUmHyYOpz2+H37RBejQc+KQOvguejwNcnSMn96PD31hwurw3A@mail.gmail.com>
Subject: Re: [PATCH 3/6] btwilink: add minimal device tree support
From: Varka Bhadram <varkabhadram@gmail.com>
To: Gigi Joseph <gigi.joseph@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-bluetooth@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Gigi Joseph <gigi.joseph@ti.com>, Eyal Reizer <eyalr@ti.com>,
        bvijay <bvijay@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 9, 2015 at 9:17 AM, Gigi Joseph <gigi.joseph@gmail.com> wrote:
> Add minimal device tree support to the btwilink driver that is used
> for binding bluetooth with the ti-st shared transport driver.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> Signed-off-by: bvijay <bvijay@ti.com>
> Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
> ---
>  drivers/bluetooth/btwilink.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
> index 55c135b..95adec3 100644
> --- a/drivers/bluetooth/btwilink.c
> +++ b/drivers/bluetooth/btwilink.c
> @@ -30,6 +30,7 @@
>
>  #include <linux/ti_wilink_st.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>
>  /* Bluetooth Driver Version */
>  #define VERSION               "1.0"
> @@ -286,6 +287,14 @@ static int ti_st_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
>         return 0;
>  }
>
> +static const struct of_device_id btwilink_of_match[] = {
> +{
> +       .compatible = "btwilink",
compatible property include the manufacturer name also...
compatible="<manufacturer>,<model>"
> +       },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, btwilink_of_match);
> +
>  static int bt_ti_probe(struct platform_device *pdev)
>  {
>         static struct ti_st *hst;
> @@ -349,6 +358,8 @@ static struct platform_driver btwilink_driver = {
>         .remove = bt_ti_remove,
>         .driver = {
>                 .name = "btwilink",
> +               .owner = THIS_MODULE,
No need to update this field. It will be updated by driver core.
> +               .of_match_table = of_match_ptr(btwilink_of_match),
>         },
>  };
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks and Regards,
Varka Bhadram.
