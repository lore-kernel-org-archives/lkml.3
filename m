Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3CNGpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:45:22 -0400
Received: from ozlabs.org ([203.10.76.45]:60259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab3CNGpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:45:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [ 12/40] hw_random: make buffer usable in scatterlist.
In-Reply-To: <874ngeykp6.wl%satoru.takeuchi@gmail.com>
References: <20130312223211.492954675@linuxfoundation.org> <20130312223212.790278686@linuxfoundation.org> <874ngeykp6.wl%satoru.takeuchi@gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 14 Mar 2013 17:11:21 +1030
Message-ID: <87txoetre6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi <satoru.takeuchi@gmail.com> writes:
> Hi Rusty,
>
> At Tue, 12 Mar 2013 15:43:33 -0700,
> Greg Kroah-Hartman wrote:
>> @@ -307,6 +312,14 @@ int hwrng_register(struct hwrng *rng)
>>  
>>  	mutex_lock(&rng_mutex);
>>  
>> +	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
>> +	err = -ENOMEM;
>> +	if (!rng_buffer) {
>> +		rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
>
> rng_buffer is now kmalloc-ed, but not kfree-ed. Shoudn't it be kfree-ed
> at hwrng_unregister()? If my suspect is correct, the same problem is
> in 3.8.3-rc1 and 3.0.69-rc1. I'm OK to make a patch, but it'll be after
> some hours.
>
> Corecct me if I'm wrong.

Yes, it would be nice to free it, but it really makes sense to free it
in module_cleanup() (which would have to be written, as the module
currently doesn't have one).

Cheers,
Rusty.
