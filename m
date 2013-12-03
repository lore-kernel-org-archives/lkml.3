Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3LCBYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:24:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34153 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3LCBYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:24:15 -0500
Message-ID: <529D32BC.2020504@ti.com>
Date: Tue, 3 Dec 2013 10:24:12 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 2/3] leds: lp5521/5523: Remove duplicate mutex
References: <1385014460-6443-1-git-send-email-milo.kim@ti.com> <CAK5ve-JEsBy6gd+oVwpnzkQe7eTmW6qkK-Rb4cM-JkKHPdiC9g@mail.gmail.com>
In-Reply-To: <CAK5ve-JEsBy6gd+oVwpnzkQe7eTmW6qkK-Rb4cM-JkKHPdiC9g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 12/03/2013 04:40 AM, Bryan Wu wrote:
> On Wed, Nov 20, 2013 at 10:14 PM, Milo Kim <milo.kim@ti.com> wrote:
>> It can be a problem when a pattern is loaded via the firmware interface.
>> LP55xx common driver has already locked the mutex in 'lp55xx_firmware_loaded()'.
>> So it should be deleted.
>>
>
> Looks like lp5521_update_program_memory() will be called by
> store_engine_load() without holding a lock after this change, is this
> correct? I think you need also update store_engine_load() to hold the
> lock when calling lp5521_update_program_memory().

Thanks, good point! I've just sent the patch-v2.

Best regards,
   Milo

