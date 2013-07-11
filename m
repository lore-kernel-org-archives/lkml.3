Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3GKXqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:46:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17674 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3GKXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:46:23 -0400
X-Spam-Score: -100.8
Message-ID: <51DF4391.4010609@asianux.com>
Date: Fri, 12 Jul 2013 07:45:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, khali@linux-fr.org,
        David.Woodhouse@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: print failure information instead of
 'KOBJ_ADD' to user space, when sysfs_create_file() fails.
References: <51DB8597.4090101@asianux.com> <87y59gcg17.fsf@rustcorp.com.au> <51DCC426.3010606@gmail.com> <51DCC867.70408@asianux.com> <51DCCE96.9050600@gmail.com>
In-Reply-To: <51DCCE96.9050600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 11:01 AM, Chen Gang F T wrote:
> 
>> > Hmm..., do we need call kobject_get() before kobject_put() in failure
>> > processing block ?
>> > 
> Oh, sorry for what I said for kobject_get/put() items above, it is
> incorrect.
> 
> What about the diff below for kobject_get() ?
> 
> -------------------------------diff begin-------------------------------
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..ef8d720 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -754,11 +754,11 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
>  				name, err);
>  			return NULL;
>  		}
> -
> -		/* So that we hold reference in both cases. */
> -		kobject_get(&mk->kobj);
>  	}
>  
> +	/* So that we hold reference in both cases. */
> +	kobject_get(&mk->kobj);
> +
>  	return mk;
>  }
> 
> -------------------------------diff end---------------------------------
> 

Sorry again, this diff is incorrect, the original implementation has no
issues.


> And it also need add additional kobject_put(), if we really need
> process the failure in version_sysfs_builtin().

If need process failure, we really need it, but now, we only use
BUG_ON() is enough.


Thanks.
-- 
Chen Gang
