Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaJWHGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:06:51 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63876 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaJWHGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:06:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141022.161257.290251379136182774.davem@davemloft.net>
References: <1413963581-24019-1-git-send-email-geert@linux-m68k.org>
	<20141022.153436.93475594748933547.davem@davemloft.net>
	<CAMuHMdXJs=+SpB07t0a+LRWX_TGUnUmQi3P-aExFzmbm_j0fow@mail.gmail.com>
	<20141022.161257.290251379136182774.davem@davemloft.net>
Date: Thu, 23 Oct 2014 09:06:48 +0200
X-Google-Sender-Auth: 8gZIFUQPsvhvBNz6jSEv8MaivRU
Message-ID: <CAMuHMdXwc1nBJx_uq4NxueF67bFLkF3XnPgpW-X6pYom1fHTUQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: xgene: Rewrite loop in xgene_enet_ecc_init()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: Iyappan Subramanian <isubramanian@apm.com>, kchudgar@apm.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:12 PM, David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Wed, 22 Oct 2014 21:50:06 +0200
>
>> On Wed, Oct 22, 2014 at 9:34 PM, David Miller <davem@davemloft.net> wrote:
>>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>>> Date: Wed, 22 Oct 2014 09:39:41 +0200
>>>
>>>> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: In function ‘xgene_enet_ecc_init’:
>>>> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:126: warning: ‘data’ may be used uninitialized in this function
>>>>
>>>> Depending on the arbitrary value on the stack, the loop may terminate
>>>> too early, and cause a bogus -ENODEV failure.
>>>>
>>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>> ---
>>>> v2: Rewrite the loop instead of pre-initializing data.
>>>
>>> I hate to be a pest, but like the other patch of your's I think
>>> a do { } while() works best here because the intent is clearly
>>> to run the loop at least once, right?
>>
>> I wanted to avoid checking for "data != ~0U" twice: once to abort the loop,
>> and once to check if a timeout happened.
>
> Hmmm:
>
>         do {
>                 usleep_range(...);
>                 data = ...();
>                 if (data == ~0)
>                         return 0;
>         } while (++i < 10);
>
>         netdev_err(...);
>         return -ENODEV;
>
> Why would you have to check data twice?

Yes, that would work to.

Feel free to do s/for (i = 0; i < 10; i++)/do/ and s/}/} while (++i < 10);/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
