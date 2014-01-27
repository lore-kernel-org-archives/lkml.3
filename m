Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaA0TIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:08:19 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53247 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaA0TIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <1390834182.1792.512.camel@misato.fc.hp.com>
References: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
	<1390834182.1792.512.camel@misato.fc.hp.com>
Date: Mon, 27 Jan 2014 11:08:18 -0800
X-Google-Sender-Auth: RMwKnPexTKyCafSUgxrGY_AYgFw
Message-ID: <CAE9FiQUZ8WD3nNAr=Y946y7=hqMfkqa72N-5fpOrGfaE4KTYfA@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: Avoid duplicated pxm_to_node() calling.
From: Yinghai Lu <yinghai@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 6:49 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Sun, 2014-01-26 at 13:01 -0800, Yinghai Lu wrote:
>> In slit init code, more pxm_to_node() calling are added.
>>
>> We can store from_node/to_node instead of keep calling pxm_to_node().
>>
>> After this patch: pxm_to_node() is called n*(1+n)
>> Before this patch: pxm_to_node() is called n*(1+n*3)
>>
>> for 8 socket, it will be 72 instead of 200.
>> for 32 socket, it will be 1056 instead of 3104.
>>
>> -v2: update title and change log according to Ingo.
>>      move from_node/to_node in loop and change to const according to
>>       David Rientjes.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> In my original patch, I added the following comment to the function to
> address David's comment (which he acked).  So, can you add this comment?
>
> -/* Callback for SLIT parsing */
> +/*
> + * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
> + * I/O localities since SRAT does not list them.  I/O localities are
> + * not supported at this point.
> + */
>
> Otherwise, the change looks good to me.
>
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Hi, Toshi,

This patch is delta patch to your patch that is in tip already.

So you comments change is still there and not touched.

Thanks

Yinghai
