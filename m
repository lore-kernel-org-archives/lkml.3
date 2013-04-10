Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937334Ab3DJK47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:56:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:52546 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936091Ab3DJK45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:56:57 -0400
X-Spam-Score: -100.8
Message-ID: <51654557.3000308@asianux.com>
Date: Wed, 10 Apr 2013 18:56:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: parameters checking, for EXPORT_SYMBOL_GPL
 functions
References: <5163AE9A.8060505@asianux.com> <871uai7tzu.fsf@rustcorp.com.au>
In-Reply-To: <871uai7tzu.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月10日 14:57, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> >   for EXPORT_SYMBOL_GPL functions, necessary to check their parameters.
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Why?
> 
> If someone misuses these functions, they crash and thus indicate that
> the caller shouldn't do that.
> 

  for me, I think:

    if it is used by self (such as static functions):
      I prefer to crash immediatly.
      it will help us to find issue, quickly.

    if it can be used by others (such as EXPORT_SYMBOL_GPL):
      I prefer to return fail and tell caller that parameter is invalid.
      it is more polite to callers, and still indicate it may be an issue.

  :-)


> Or is someone already doing this?
> 

  really has:

    kernel: __wake_up_sync_key in kernel/sched/core.c.
    lib: *printf.
    mm:  kfree.


> Confused,
> Rusty.
> 


-- 
Chen Gang

Asianux Corporation
