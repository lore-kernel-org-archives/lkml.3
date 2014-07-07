Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaGGKxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:53:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50744 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaGGKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <CANLsYky0keX_z0ZggTxst2SfLxB7i1YgcWBOkiV08KHo8mySSw@mail.gmail.com>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
	<1401457391-12242-3-git-send-email-mathieu.poirier@linaro.org>
	<CACRpkdYnFBP8RbOhePed+sq+tk=syME4Trwtd+PgfAyht+3Zqg@mail.gmail.com>
	<CANLsYky0keX_z0ZggTxst2SfLxB7i1YgcWBOkiV08KHo8mySSw@mail.gmail.com>
Date: Mon, 7 Jul 2014 12:53:10 +0200
Message-ID: <CACRpkdYXD=nxBCZdRKah5xjNRCXtFgXDMRq8WyEtjX09wkeS6A@mail.gmail.com>
Subject: Re: [RFC PATCH 02/11] coresight: add CoreSight TMC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 1:12 AM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
> On 3 June 2014 03:09, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, May 30, 2014 at 3:43 PM,  <mathieu.poirier@linaro.org> wrote:

>>> +       int                     read_count;
>>
>> Can this really be negative?
>
> It is useful for debugging, as an example see "tmc_release()".  If the
> count drops below '0' there is obviously a problem.  Do you see a cost
> in keeping this as an 'int'?  What do you advise here?

No big deal, keep it.

>> This struct overall could use some kerneldoc.
>
> Would writing a comment for each field qualify?

Like above the struct, see Documentation/kernel-doc-nano-HOWTO.txt

>>> +       drvdata->base = devm_ioremap(dev, res->start, resource_size(res));
>>
>> Use devm_ioremap_resource() instead.
>
> I'm working on it.

Bet it's fininshed now ;-)

Yours,
Linus Walleij
