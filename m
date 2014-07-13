Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaGMWia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 18:38:30 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35601 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGMWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 18:38:27 -0400
Message-ID: <53C30A60.4050901@gmail.com>
Date: Mon, 14 Jul 2014 06:38:24 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: bergwolf@gmail.com, andreas.dilger@intel.com, standby24x7@gmail.com,
        oleg.drokin@intel.com, Andriy_Skulysh@xyratex.com,
        denis.pithon@gmail.com, paf@cray.com, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: Use 'force_die' instead of
 'die' to avoid compiling issue
References: <53C29CCF.9010008@gmail.com> <20140713190512.GA27311@kroah.com> <53C2FD24.5090506@gmail.com> <53C308A7.7080703@gmail.com>
In-Reply-To: <53C308A7.7080703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 06:31 AM, Chen Gang wrote:
> On 07/14/2014 05:41 AM, Chen Gang wrote:
>> On 07/14/2014 03:05 AM, Greg Kroah-Hartman wrote:
>>> On Sun, Jul 13, 2014 at 10:50:55PM +0800, Chen Gang wrote:
>>>> Some of architectures have already defined 'die' as macro, so can not use
>>>> this common name as declaration in other modules, or will cause compiling
>>>> issue. So use more precise name 'force_die' (like 'wrap_bulk') instead of.
>>>>
>>>> The related error (with allmodconfig under score):
>>>>
>>>>     CC [M]  drivers/staging/lustre/lustre/ptlrpc/sec.o
>>>>   drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'sptlrpc_cli_ctx_expire':
>>>>   drivers/staging/lustre/lustre/ptlrpc/sec.c:309:13: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
>>>>     ctx->cc_ops->die(ctx, 0);
>>>>                ^
>>>>   drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'ctx_refresh_timeout':
>>>>   drivers/staging/lustre/lustre/ptlrpc/sec.c:594:26: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
>>>>      req->rq_cli_ctx->cc_ops->die(req->rq_cli_ctx, 0);
>>>>                             ^
>>>>   make[5]: *** [drivers/staging/lustre/lustre/ptlrpc/sec.o] Error 1
>>>>   make[4]: *** [drivers/staging/lustre/lustre/ptlrpc] Error 2
>>>>   make[3]: *** [drivers/staging/lustre/lustre] Error 2
>>>>   make[2]: *** [drivers/staging/lustre] Error 2
>>>>   make[1]: *** [drivers/staging] Error 2
>>>>   make: *** [drivers] Error 2
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>> ---
>>>>  drivers/staging/lustre/lustre/include/lustre_sec.h | 2 +-
>>>>  drivers/staging/lustre/lustre/ptlrpc/sec.c         | 6 +++---
>>>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>> This doesn't apply to my tree, can you please refresh it against the
>>> staging-next branch of staging.git so that I can apply it?
>>>
> 
> 
> After checkout, I get the same patch, the related git link:
> 
>   "git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git".

Oh, sorry, maybe I need:

  "git clone -b staging-next git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git"

And I shall try again, and finish within 2 days.

Thanks.

> 
> The related new patch is in attachment, please check, thanks.
> 
> 
>>
>> OK, I shall go to that tree and send patch for it (I shall finish within
>> 2 days).
> 
> 
> Thanks.
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
