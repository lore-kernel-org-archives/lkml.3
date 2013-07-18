Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3GRGvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:51:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14244 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3GRGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:51:52 -0400
X-Spam-Score: -100.8
Message-ID: <51E7904C.8060100@asianux.com>
Date: Thu, 18 Jul 2013 14:50:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: andrei.emeltchenko@intel.com, andriy.shevchenko@linux.intel.com,
        jkosina@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf.c: fix the incorrect return value of vsnprintf()
References: <20130718064238.25532.qmail@science.horizon.com>
In-Reply-To: <20130718064238.25532.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 02:42 PM, George Spelvin wrote:
>> When "str >= end", necessary to reset 'str' to "end - 1", or the return
>> > value will be larger than the real one, the callers which depend on the
>> > return value, may cause memory overflow.
> NAK.  This is the documented (by both the function itself and the
> ANSI/ISO C standard) and desired return value: the number of bytes that
> *would* have been in the output string if the buffer were large enough.
> In particular, it is common to do:
> 
> size = vsnprintf(NULL, 0, fmt, args) + 1;
> p = malloc(size, GFP_KERNEL);
> vsnprintf(p, size, fmt, args);
> 

OK, it is my fault, thank you very much.

> You want vscnprintf.  If you have a caller that needs the *actual* number of
> bytes written, use that.
> 
> 

Yeah, my another patch need use vscnprintf() instead of vsnprintf(),
thanks again.


Thanks.
-- 
Chen Gang
