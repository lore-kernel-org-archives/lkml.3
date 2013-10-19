Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3JSXN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 19:13:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64641 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3JSXN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 19:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131019.184919.1292439830365652584.davem@davemloft.net>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
	<20131019.183825.2015665991258674429.davem@davemloft.net>
	<CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
	<20131019.184919.1292439830365652584.davem@davemloft.net>
Date: Sat, 19 Oct 2013 20:13:25 -0300
Message-ID: <CAGG-pUSfA7ynQM3OEFqHaac3vh3BooisGq2rKO5OmAE_cdKb9A@mail.gmail.com>
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/19 David Miller <davem@davemloft.net>:
> From: Geyslan Gregório Bem <geyslan@gmail.com>
> Date: Sat, 19 Oct 2013 19:42:35 -0300
>
>> 2013/10/19 David Miller <davem@davemloft.net>:
>>> From: "Geyslan G. Bem" <geyslan@gmail.com>
>>> Date: Sat, 19 Oct 2013 10:09:31 -0300
>>>
>>>> This patch moves the '!err' condition into the above else scope,
>>>> what is more obvious and has the secondary goal of avoid false-positives
>>>> in statical analyze tools.
>>>>
>>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>>>
>>> I do not think patches should be applied to satisfy tools if the
>>> code is semantically correct.
>>
>> Yes, Miller, I agree. But as I mentioned:
>> ".. and has as the 'secondary' goal of avoid false-positives in
>> statical analyze tools."
>>
>> The 'primary' goal is to not repeat a condition test:
>> "This patch moves the '!err' condition into the above else scope, what
>> is more obvious ..."
>
> I still do not feel that this change is a net-positive.  Sorry.
Miller,

I can understand you. You don't want to break your git history
(blame). But when a code is clearly more readable/understandable you
must assume that it has a huge net-positive.

The patch improves the code in three ways:
- Only one if/else;
- Not blame on static analysis tools.
- And avoid more discussion about that in the future (nobody will send
patches like this to disturb you about that part of code).

The decision is yours.

Thanks again.
