Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaDVTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:15:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34766 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbaDVTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:15:21 -0400
X-Sasl-enc: KqOx2RVqNWQlJxTrzTZ6s+WtYeJlk5EMi111+jsr4b7Q 1398194118
Date: Tue, 22 Apr 2014 09:38:56 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] samples/kobject/: avoid world-writable sysfs files.
Message-ID: <20140422163856.GB23831@kroah.com>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
 <1398137612-9714-9-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398137612-9714-9-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:03:31PM +0930, Rusty Russell wrote:
> In line with practice for module parameters, we're adding a build-time
> check that sysfs files aren't world-writable.
> 
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  samples/kobject/kobject-example.c | 7 ++++---
>  samples/kobject/kset-example.c    | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
> index 86ea0c3ad975..01562e0d4992 100644
> --- a/samples/kobject/kobject-example.c
> +++ b/samples/kobject/kobject-example.c
> @@ -40,8 +40,9 @@ static ssize_t foo_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	return count;
>  }
>  
> +/* Sysfs attributes cannot be world-writable. */
>  static struct kobj_attribute foo_attribute =
> -	__ATTR(foo, 0666, foo_show, foo_store);
> +	__ATTR(foo, 0664, foo_show, foo_store);

__ATTR_RW()?

>  
>  /*
>   * More complex function where we determine which variable is being accessed by
> @@ -73,9 +74,9 @@ static ssize_t b_store(struct kobject *kobj, struct kobj_attribute *attr,
>  }
>  
>  static struct kobj_attribute baz_attribute =
> -	__ATTR(baz, 0666, b_show, b_store);
> +	__ATTR(baz, 0664, b_show, b_store);
>  static struct kobj_attribute bar_attribute =
> -	__ATTR(bar, 0666, b_show, b_store);
> +	__ATTR(bar, 0664, b_show, b_store);

Same for these.

>  
>  
>  /*
> diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
> index 5dce351f131f..ab5e447ec238 100644
> --- a/samples/kobject/kset-example.c
> +++ b/samples/kobject/kset-example.c
> @@ -124,8 +124,9 @@ static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  	return count;
>  }
>  
> +/* Sysfs attributes cannot be world-writable. */
>  static struct foo_attribute foo_attribute =
> -	__ATTR(foo, 0666, foo_show, foo_store);
> +	__ATTR(foo, 0664, foo_show, foo_store);
>  
>  /*
>   * More complex function where we determine which variable is being accessed by
> @@ -157,9 +158,9 @@ static ssize_t b_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
>  }
>  
>  static struct foo_attribute baz_attribute =
> -	__ATTR(baz, 0666, b_show, b_store);
> +	__ATTR(baz, 0664, b_show, b_store);
>  static struct foo_attribute bar_attribute =
> -	__ATTR(bar, 0666, b_show, b_store);
> +	__ATTR(bar, 0664, b_show, b_store);

And these.

Thanks for sweeping the tree for this type of thing, but we might as
well get the macro usage right when we are doing it.

thanks,

greg k-h
