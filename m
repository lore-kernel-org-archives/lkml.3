Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3HZLmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:42:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab3HZLmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:42:07 -0400
Date: Mon, 26 Aug 2013 13:42:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] HID: convert bus code to use dev_groups
In-Reply-To: <1377293081-10957-12-git-send-email-gregkh@linuxfoundation.org>
Message-ID: <alpine.LNX.2.00.1308261341550.2077@pobox.suse.cz>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org> <1377293081-10957-12-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Greg Kroah-Hartman wrote:

> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the HID bus code to use
> the correct field.
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Jiri Kosina <jkosina@suse.cz>

> ---
>  drivers/hid/hid-core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 36668d1a..b8f1c77f 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1917,11 +1917,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
>  
>  	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
>  }
> +static DEVICE_ATTR_RO(modalias);
>  
> -static struct device_attribute hid_dev_attrs[] = {
> -	__ATTR_RO(modalias),
> -	__ATTR_NULL,
> +static struct attribute *hid_dev_attrs[] = {
> +	&dev_attr_modalias.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(hid_dev);
>  
>  static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> @@ -1949,7 +1951,7 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
>  
>  static struct bus_type hid_bus_type = {
>  	.name		= "hid",
> -	.dev_attrs	= hid_dev_attrs,
> +	.dev_groups	= hid_dev_groups,
>  	.match		= hid_bus_match,
>  	.probe		= hid_device_probe,
>  	.remove		= hid_device_remove,
> -- 
> 1.8.3.rc0.20.gb99dd2e
> 

-- 
Jiri Kosina
SUSE Labs
