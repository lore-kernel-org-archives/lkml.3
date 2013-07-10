Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3GJWs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:48:59 -0400
Received: from mail-pb0-f65.google.com ([209.85.160.65]:53099 "EHLO
	mail-pb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3GJWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:48:58 -0400
Date: Wed, 10 Jul 2013 15:48:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH 2/6] sysfs.h: add ATTRIBUTE_GROUPS() macro
Message-ID: <20130710224856.GA21305@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:05:10PM -0700, Greg Kroah-Hartman wrote:
> To make it easier for driver subsystems to work with attribute groups,
> create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
> typing for the most common use for attribute groups.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/sysfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 9cd20c8..f62ff01 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -94,6 +94,15 @@ struct attribute_group {
>  #define __ATTR_IGNORE_LOCKDEP	__ATTR
>  #endif
>  
> +#define ATTRIBUTE_GROUPS(name)					\

Would it be possible to add is_visible as additional argument ?

Thanks,
Guenter

> +static const struct attribute_group name##_group = {		\
> +	.attrs = name##_attrs,					\
> +};								\
> +static const struct attribute_group *name##_groups[] = {	\
> +	&name##_group,						\
> +	NULL,							\
> +}
> +
>  #define attr_name(_attr) (_attr).attr.name
>  
>  struct file;
> -- 
> 1.8.3.rc0.20.gb99dd2e
> 
> 
