Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3KEWlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:41:44 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34500 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3KEWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:41:42 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <52796BE1.5010306@wwwdotorg.org>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
	<52794823.7080503@kernel.dk>
	<CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
	<20131105203308.3802.45122@localhost.localdomain>
	<CAOesGMirg=ex9hLCjGBpj0cMhLeQ5cJQoRv72tgg7PoSKWUDhA@mail.gmail.com>
	<20131105205623.3802.5166@localhost.localdomain>
	<52796BE1.5010306@wwwdotorg.org>
Date: Tue, 5 Nov 2013 14:41:42 -0800
Message-ID: <CAOesGMiyp3VNUZf=A_MMVAKsdqtE8nJqNuNCmZh6PO2zkU-oTA@mail.gmail.com>
Subject: Re: Boot failure on Arndale with next-20131105
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Chris Mason <chris.mason@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Tushar Behera <tushar.behera@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 2:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/05/2013 01:56 PM, Chris Mason wrote:
>> Quoting Olof Johansson (2013-11-05 15:38:33)
>>> On Tue, Nov 5, 2013 at 12:33 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>>>> Quoting Olof Johansson (2013-11-05 15:23:51)
>>>>> On Tue, Nov 5, 2013 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> [ horrible crashes fixed by removing my patch ]
>>>>
> ...
>> Ok, I think I see it.  My guess is that you're hitting bounce buffers.
>> __blk_queue_bounce is the only caller of the bio splitting code I can
>> see that you might be hitting.
>>
>> My first patch exposed a lurking bug in bio_clone_biovec.  Basically
>> bio->bi_vcnt is being doubled instead of initialized.
>>
>> This patch is only compile tested, but I think it'll fix it.
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> (this fixes the issue on Tegra30/Beaver at least)

Tested-by: Olof Johansson <olof@lixom.net>

This resolves boot failures on:
* Tegra30/beaver
* OMAP4/panda
* i.MX6/wandboard

Thanks Chris!

-Olof
