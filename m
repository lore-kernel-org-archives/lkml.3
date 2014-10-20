Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaJTVAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:00:43 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38491 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaJTVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:00:41 -0400
MIME-Version: 1.0
In-Reply-To: <54442FE5.8080705@ramsay1.demon.co.uk>
References: <CABbAP1QWTorBt+f-nCmw1Q_DPe1CLecXYGUJFAcQkuw0Rk6d2g@mail.gmail.com>
	<5443F319.4000303@infradead.org>
	<54442FE5.8080705@ramsay1.demon.co.uk>
Date: Mon, 20 Oct 2014 23:00:40 +0200
Message-ID: <CABbAP1RzO-D+AC4qTY8RZmp4M0wBxupqmFj3Jz132=Lhw4kzoQ@mail.gmail.com>
Subject: Re: Sparse warning: "initializer entry defined twice" - sparse can't
 handle bool?
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I've actually used outdated sparse in version 0.4.3. After
updating to the latest one, built from master in git repo, the issue
is gone. Thanks.

On 19 October 2014 23:40, Ramsay Jones <ramsay@ramsay1.demon.co.uk> wrote:
> On 19/10/14 18:21, Randy Dunlap wrote:
>> [adding linux-sparse mailing list]
>>
>> On 10/19/14 02:46, Mariusz Gorski wrote:
>>> Sparse throws the following warning, which I can't really understand:
>>>
>>> $ make drivers/staging/vt6655/ C=2
>>> [...]
>>>   CHECK   drivers/staging/vt6655/datarate.c
>>> drivers/staging/vt6655/datarate.c:302:40: warning: Initializer entry
>>> defined twice
>>> drivers/staging/vt6655/datarate.c:302:46:   also defined here
>>>
>>> The code looks fine to me:
>>> bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false,
>>> true, true, true, true, true, true};
>>>
>>> I've googled it and found only this LKML discussion:
>>> https://lkml.org/lkml/2010/5/7/31
>>>
>>> I've tested the suggested code sample and here are the results:
>>> $ cat foo.c
>>> typedef _Bool bool;
>>> enum {
>>>      false = 0,
>>>      true = 1
>>> };
>>> static const bool foo[10] = {
>>>        true,
>>>        true,
>>>        false,
>>>        false,
>>> };
>>>
>>> $ sparse foo.c
>>> foo.c:7:8: warning: Initializer entry defined twice
>>> foo.c:8:8:   also defined here
>>>
>>> It this a sparse problem?
>
> Yes, I imagine you are using a sparse version of v0.5.0 or
> earlier right?
>
> This was fixed by commit b3e9d87c6 ("sparse: make bits_to_bytes
> round up instead of down", 16-07-2014), which describes to
> v0.5.0-17-gb3e9d87, which has not been included in a released
> version yet. (if you don't mind building from source, you could
> build the master branch using a clone the git repository at
> git://git.kernel.org/pub/scm/devel/sparse/sparse.git).
>
> I'm afraid that I don't know when the next release is due.
>
> HTH
>
> ATB,
> Ramsay Jones
>
>
