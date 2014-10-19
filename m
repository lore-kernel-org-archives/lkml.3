Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaJSVsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:48:14 -0400
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:55777 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbaJSVsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:48:10 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 17:48:10 EDT
Message-ID: <54442FE5.8080705@ramsay1.demon.co.uk>
Date: Sun, 19 Oct 2014 22:40:53 +0100
From: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Mariusz Gorski <marius.gorski@gmail.com>, linux-kernel@vger.kernel.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Subject: Re: Sparse warning: "initializer entry defined twice" - sparse can't
 handle bool?
References: <CABbAP1QWTorBt+f-nCmw1Q_DPe1CLecXYGUJFAcQkuw0Rk6d2g@mail.gmail.com> <5443F319.4000303@infradead.org>
In-Reply-To: <5443F319.4000303@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/14 18:21, Randy Dunlap wrote:
> [adding linux-sparse mailing list]
> 
> On 10/19/14 02:46, Mariusz Gorski wrote:
>> Sparse throws the following warning, which I can't really understand:
>>
>> $ make drivers/staging/vt6655/ C=2
>> [...]
>>   CHECK   drivers/staging/vt6655/datarate.c
>> drivers/staging/vt6655/datarate.c:302:40: warning: Initializer entry
>> defined twice
>> drivers/staging/vt6655/datarate.c:302:46:   also defined here
>>
>> The code looks fine to me:
>> bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false,
>> true, true, true, true, true, true};
>>
>> I've googled it and found only this LKML discussion:
>> https://lkml.org/lkml/2010/5/7/31
>>
>> I've tested the suggested code sample and here are the results:
>> $ cat foo.c
>> typedef _Bool bool;
>> enum {
>>      false = 0,
>>      true = 1
>> };
>> static const bool foo[10] = {
>>        true,
>>        true,
>>        false,
>>        false,
>> };
>>
>> $ sparse foo.c
>> foo.c:7:8: warning: Initializer entry defined twice
>> foo.c:8:8:   also defined here
>>
>> It this a sparse problem?

Yes, I imagine you are using a sparse version of v0.5.0 or
earlier right?

This was fixed by commit b3e9d87c6 ("sparse: make bits_to_bytes
round up instead of down", 16-07-2014), which describes to
v0.5.0-17-gb3e9d87, which has not been included in a released
version yet. (if you don't mind building from source, you could
build the master branch using a clone the git repository at
git://git.kernel.org/pub/scm/devel/sparse/sparse.git).

I'm afraid that I don't know when the next release is due.

HTH

ATB,
Ramsay Jones


