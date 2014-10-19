Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaJSRVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:21:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:41155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaJSRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:21:33 -0400
Message-ID: <5443F319.4000303@infradead.org>
Date: Sun, 19 Oct 2014 10:21:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mariusz Gorski <marius.gorski@gmail.com>, linux-kernel@vger.kernel.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Subject: Re: Sparse warning: "initializer entry defined twice" - sparse can't
 handle bool?
References: <CABbAP1QWTorBt+f-nCmw1Q_DPe1CLecXYGUJFAcQkuw0Rk6d2g@mail.gmail.com>
In-Reply-To: <CABbAP1QWTorBt+f-nCmw1Q_DPe1CLecXYGUJFAcQkuw0Rk6d2g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding linux-sparse mailing list]

On 10/19/14 02:46, Mariusz Gorski wrote:
> Sparse throws the following warning, which I can't really understand:
> 
> $ make drivers/staging/vt6655/ C=2
> [...]
>   CHECK   drivers/staging/vt6655/datarate.c
> drivers/staging/vt6655/datarate.c:302:40: warning: Initializer entry
> defined twice
> drivers/staging/vt6655/datarate.c:302:46:   also defined here
> 
> The code looks fine to me:
> bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false,
> true, true, true, true, true, true};
> 
> I've googled it and found only this LKML discussion:
> https://lkml.org/lkml/2010/5/7/31
> 
> I've tested the suggested code sample and here are the results:
> $ cat foo.c
> typedef _Bool bool;
> enum {
>      false = 0,
>      true = 1
> };
> static const bool foo[10] = {
>        true,
>        true,
>        false,
>        false,
> };
> 
> $ sparse foo.c
> foo.c:7:8: warning: Initializer entry defined twice
> foo.c:8:8:   also defined here
> 
> It this a sparse problem?
> 
> Thanks,
> Mariusz
> --


-- 
~Randy
