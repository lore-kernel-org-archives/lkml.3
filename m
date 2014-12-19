Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaLSBjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:39:11 -0500
Received: from ozlabs.org ([103.22.144.67]:43292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaLSBiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:38:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rastislav Barlik <barlik@zoho.com>
Cc: linux-kernel@vger.kernel.org, Rastislav Barlik <barlik@zoho.com>
Cc: "greg KH" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] samples/kobject: Use kstrtoint instead of sscanf
In-Reply-To: <1418718668-3646-1-git-send-email-barlik@zoho.com>
References: <1418718668-3646-1-git-send-email-barlik@zoho.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 11:27:37 +1030
Message-ID: <87388ctq0u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rastislav Barlik <barlik@zoho.com> writes:
> Use kstrtoint function instead of sscanf and check for return values.
>
> Signed-off-by: Rastislav Barlik <barlik@zoho.com>

Hmm, this seems like Greg, not me.

Greg, I noticed this in samples/kobject/kobject-example.c:

 * Released under the GPL version 2 only.
...
MODULE_LICENSE("GPL");

>From module.h:

 * The following license idents are currently accepted as indicating free
 * software modules
 *
 *	"GPL"				[GNU Public License v2 or later]
 *	"GPL v2"			[GNU Public License v2]

Cheers,
Rusty.

> ---
>  samples/kobject/kobject-example.c | 14 +++++++++++---
>  samples/kobject/kset-example.c    | 14 +++++++++++---
>  2 files changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
> index 01562e0..063aaec 100644
> --- a/samples/kobject/kobject-example.c
> +++ b/samples/kobject/kobject-example.c
> @@ -36,7 +36,12 @@ static ssize_t foo_show(struct kobject *kobj, struct kobj_attribute *attr,
>  static ssize_t foo_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			 const char *buf, size_t count)
>  {
> -	sscanf(buf, "%du", &foo);
> +	int ret;
> +
> +	ret = kstrtoint(buf, 10, &foo);
> +	if (ret < 0)
> +		return ret;
> +
>  	return count;
>  }
>  
> @@ -63,9 +68,12 @@ static ssize_t b_show(struct kobject *kobj, struct kobj_attribute *attr,
>  static ssize_t b_store(struct kobject *kobj, struct kobj_attribute *attr,
>  		       const char *buf, size_t count)
>  {
> -	int var;
> +	int var, ret;
> +
> +	ret = kstrtoint(buf, 10, &var);
> +	if (ret < 0)
> +		return ret;
>  
> -	sscanf(buf, "%du", &var);
>  	if (strcmp(attr->attr.name, "baz") == 0)
>  		baz = var;
>  	else
> diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
> index ab5e447..e80ced3 100644
> --- a/samples/kobject/kset-example.c
> +++ b/samples/kobject/kset-example.c
> @@ -120,7 +120,12 @@ static ssize_t foo_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  			 const char *buf, size_t count)
>  {
> -	sscanf(buf, "%du", &foo_obj->foo);
> +	int ret;
> +
> +	ret = kstrtoint(buf, 10, &foo_obj->foo);
> +	if (ret < 0)
> +		return ret;
> +
>  	return count;
>  }
>  
> @@ -147,9 +152,12 @@ static ssize_t b_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  static ssize_t b_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  		       const char *buf, size_t count)
>  {
> -	int var;
> +	int var, ret;
> +
> +	ret = kstrtoint(buf, 10, &var);
> +	if (ret < 0)
> +		return ret;
>  
> -	sscanf(buf, "%du", &var);
>  	if (strcmp(attr->attr.name, "baz") == 0)
>  		foo_obj->baz = var;
>  	else
> -- 
> 2.1.3
