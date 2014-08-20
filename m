Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaHTUUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:20:20 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43996 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaHTUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140820201051.GA1745@roeck-us.net>
References: <1408562806-22950-1-git-send-email-bobby.prani@gmail.com> <20140820201051.GA1745@roeck-us.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 16:19:44 -0400
Message-ID: <CAJhHMCAnda9rL6zrK2a7w1vjx_TbtFCab_C25jYf+XYAPGxJeg@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc: booke_wdt: Fix build error as a module
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 4:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Aug 20, 2014 at 03:26:46PM -0400, Pranith Kumar wrote:
>> Building booke_wdt fails when trying to build as a module as there is no
>> early_param() in module. Fix by using module_param() instead of early_param().
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> CC: Guenter Roeck <linux@roeck-us.net>
>
> Looks good as far as I can see. One question though:
>
>> +MODULE_ALIAS("booke_wdt");
>
> Is this necessary ? If yes, shouldn't it be a separate patch to be applied
> to -stable ?

Suppose this was actually built as a module. How do you pass the
module parameters to this module? Only ways I know of are

./insmod booke_wdt booke_wdt_enabled=1 booke_wdt_period=3

or pass booke_wdt.booke_wdt_enabled=1 on the kernel boot params list.

So the alias is necessary to refer to this module to pass params.

About separate patch, I think it is only with conversion to
module_param() that we need this alias.

Am I missing something?

-- 
Pranith
