Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbaCSNXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:23:32 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933771AbaCSNXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:23:31 -0400
Message-ID: <53299A41.9050701@nod.at>
Date: Wed, 19 Mar 2014 14:23:13 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] UBI: block: Implement kernel_param_ops->get()
References: <1395225803-25037-1-git-send-email-richard@nod.at> <1395225803-25037-2-git-send-email-richard@nod.at> <20140319131543.GA529@arch.cereza>
In-Reply-To: <20140319131543.GA529@arch.cereza>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.03.2014 14:15, schrieb Ezequiel Garcia:
> Hi Richard,
> 
> On Mar 19, Richard Weinberger wrote:
>> The ->get() function is not optional.
>>
> 
> [..]
>>  static struct kernel_param_ops ubiblock_param_ops = {
>>  	.set    = ubiblock_set_param,
>> +	.get	= param_get_charp,
>>  };
>>  module_param_cb(block, &ubiblock_param_ops, NULL, 0);
> 
> The comment for the function says they are both optional:
> 
> /**
>  * module_param_cb - general callback for a module/cmdline parameter
>  * @name: a valid C identifier which is the parameter name.
>  * @ops: the set & get operations for this parameter.
>  * @perm: visibility in sysfs.
>  *
>  * The ops can have NULL set or get functions.
>  */
> 
> This has no visibility in sysfs, so I can't see how having a NULL
> get() is a problem. What's the issue you're trying to fix here?
> 
> Maybe I'm missing something?
> 

Maybe I've misread the struct.

struct kernel_param_ops {
        /* How the ops should behave */
        unsigned int flags;
        /* Returns 0, or -errno.  arg is in kp->arg. */
        int (*set)(const char *val, const struct kernel_param *kp);
        /* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
        int (*get)(char *buffer, const struct kernel_param *kp);
        /* Optional function to free kp->arg when module unloaded. */
        void (*free)(void *arg);
};

To me it looks like only ->free is optional.

Thanks,
//richard
