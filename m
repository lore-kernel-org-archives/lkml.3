Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaJHOkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbaJHOkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:40:42 -0400
Date: Wed, 8 Oct 2014 16:37:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modules, lock around setting of MODULE_STATE_UNFORMED
Message-ID: <20141008143743.GA4835@redhat.com>
References: <1412772123-18522-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412772123-18522-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Prarit Bhargava wrote:
>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1842,7 +1842,9 @@ static void free_module(struct module *mod)
>  
>  	/* We leave it in list to prevent duplicate loads, but make sure
>  	 * that noone uses it while it's being deconstructed. */
> +	mutex_lock(&module_mutex);
>  	mod->state = MODULE_STATE_UNFORMED;
> +	mutex_unlock(&module_mutex);
>  
>  	/* Remove dynamic debug info */
>  	ddebug_remove_module(mod->name);

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

