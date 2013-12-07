Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3LGUwC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 15:52:02 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53647 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab3LGUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 15:52:00 -0500
Message-ID: <52A38A6C.6040005@vmware.com>
Date: Sat, 07 Dec 2013 21:51:56 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - fix sysfs layout
References: <20131207154116.GA9902@core.coreip.homeip.net>
In-Reply-To: <20131207154116.GA9902@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2013 04:41 PM, Dmitry Torokhov wrote:
> Restore previous layout of sysfs attributes that was broken by commit
> 3778a2129bcce84f684cc0017ed20d2524afd289 (input: serio: remove bus usage of
> dev_attrs) which moved all serio device attributes into 'id' group, when
> only 'type', 'proto', 'id', and 'extra' should be in 'id' group and the
> rest of attributes should be attached directly to the device.

Thanks for doing this. Makes vmmouse work again.

>
> Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Tested-by: Thomas Hellstrom <thellstrom@vmware.com>


> ---
>   drivers/input/serio/serio.c | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index 98707fb..8f4c4ab 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -455,16 +455,26 @@ static DEVICE_ATTR_RO(type);
>   static DEVICE_ATTR_RO(proto);
>   static DEVICE_ATTR_RO(id);
>   static DEVICE_ATTR_RO(extra);
> -static DEVICE_ATTR_RO(modalias);
> -static DEVICE_ATTR_WO(drvctl);
> -static DEVICE_ATTR(description, S_IRUGO, serio_show_description, NULL);
> -static DEVICE_ATTR(bind_mode, S_IWUSR | S_IRUGO, serio_show_bind_mode, serio_set_bind_mode);
>   
>   static struct attribute *serio_device_id_attrs[] = {
>   	&dev_attr_type.attr,
>   	&dev_attr_proto.attr,
>   	&dev_attr_id.attr,
>   	&dev_attr_extra.attr,
> +	NULL
> +};
> +
> +static struct attribute_group serio_id_attr_group = {
> +	.name	= "id",
> +	.attrs	= serio_device_id_attrs,
> +};
> +
> +static DEVICE_ATTR_RO(modalias);
> +static DEVICE_ATTR_WO(drvctl);
> +static DEVICE_ATTR(description, S_IRUGO, serio_show_description, NULL);
> +static DEVICE_ATTR(bind_mode, S_IWUSR | S_IRUGO, serio_show_bind_mode, serio_set_bind_mode);
> +
> +static struct attribute *serio_device_attrs[] = {
>   	&dev_attr_modalias.attr,
>   	&dev_attr_description.attr,
>   	&dev_attr_drvctl.attr,
> @@ -472,13 +482,13 @@ static struct attribute *serio_device_id_attrs[] = {
>   	NULL
>   };
>   
> -static struct attribute_group serio_id_attr_group = {
> -	.name	= "id",
> -	.attrs	= serio_device_id_attrs,
> +static struct attribute_group serio_device_attr_group = {
> +	.attrs	= serio_device_attrs,
>   };
>   
>   static const struct attribute_group *serio_device_attr_groups[] = {
>   	&serio_id_attr_group,
> +	&serio_device_attr_group,
>   	NULL
>   };
>   
