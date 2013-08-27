Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3H0MfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:35:25 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57935 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3H0MfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:35:23 -0400
Message-ID: <521C9D14.7090502@linaro.org>
Date: Tue, 27 Aug 2013 07:35:32 -0500
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Yehuda Sadeh <yehuda@inktank.com>,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 02/15] rbd: convert bus code to use bus_groups
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org> <1377293081-10957-2-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1377293081-10957-2-git-send-email-gregkh@linuxfoundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 04:24 PM, Greg Kroah-Hartman wrote:
> The bus_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the RBD bus code to use the
> correct field.
> 
> Cc: Yehuda Sadeh <yehuda@inktank.com>
> Cc: Sage Weil <sage@inktank.com>
> Cc: Alex Elder <elder@inktank.com>

Looks reasonable to me.

Acked-by: Alex Elder <elder@linaro.org>

> Cc: <ceph-devel@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/block/rbd.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 4ad2ad9a..191cd177 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -397,15 +397,19 @@ static ssize_t rbd_remove(struct bus_type *bus, const char *buf,
>  static int rbd_dev_image_probe(struct rbd_device *rbd_dev, bool mapping);
>  static void rbd_spec_put(struct rbd_spec *spec);
>  
> -static struct bus_attribute rbd_bus_attrs[] = {
> -	__ATTR(add, S_IWUSR, NULL, rbd_add),
> -	__ATTR(remove, S_IWUSR, NULL, rbd_remove),
> -	__ATTR_NULL
> +static BUS_ATTR(add, S_IWUSR, NULL, rbd_add);
> +static BUS_ATTR(remove, S_IWUSR, NULL, rbd_remove);
> +
> +static struct attribute *rbd_bus_attrs[] = {
> +	&bus_attr_add.attr,
> +	&bus_attr_remove.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(rbd_bus);
>  
>  static struct bus_type rbd_bus_type = {
>  	.name		= "rbd",
> -	.bus_attrs	= rbd_bus_attrs,
> +	.bus_groups	= rbd_bus_groups,
>  };
>  
>  static void rbd_root_dev_release(struct device *dev)
> 

