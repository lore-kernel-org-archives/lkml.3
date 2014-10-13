Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaJMGyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:54:49 -0400
Received: from ozlabs.org ([103.22.144.67]:60712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbaJMGyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:54:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>, Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modules, lock around setting of MODULE_STATE_UNFORMED
In-Reply-To: <20141008143743.GA4835@redhat.com>
References: <1412772123-18522-1-git-send-email-prarit@redhat.com> <20141008143743.GA4835@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 16:11:26 +1030
Message-ID: <87egucedbt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:
> On 10/08, Prarit Bhargava wrote:
>>
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1842,7 +1842,9 @@ static void free_module(struct module *mod)
>>  
>>  	/* We leave it in list to prevent duplicate loads, but make sure
>>  	 * that noone uses it while it's being deconstructed. */
>> +	mutex_lock(&module_mutex);
>>  	mod->state = MODULE_STATE_UNFORMED;
>> +	mutex_unlock(&module_mutex);
>>  
>>  	/* Remove dynamic debug info */
>>  	ddebug_remove_module(mod->name);
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Thanks, good catch.

I've cc'd stable too.

Cheers,
Rusty.

