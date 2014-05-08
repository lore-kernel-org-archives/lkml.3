Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaEHMzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:55:09 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:45619 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaEHMzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <4314054.Zr5Mecf9vm@wuerfel>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
	<1399499298-8830-4-git-send-email-robherring2@gmail.com>
	<4314054.Zr5Mecf9vm@wuerfel>
Date: Thu, 8 May 2014 07:55:06 -0500
Message-ID: <CAL_JsqJEW_Xrfi7OiF6caHVup1Y6-8SvyOJawov8o3oiYiFvXQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/platform: fix device naming for non-translatable addresses
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 5:41 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 07 May 2014 16:48:17 Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Using non-translatable addresses in platform device names is wrong
>> because they may not be globally unique. Just use the default naming with
>> a global index if the address cannot be translated instead.
>>
>> of_can_translate_address has the same checks as of_translate_address, so
>> we can remove it here as well.
>
> Have you checked that this doesn't break platforms using clkdev lookup
> based on names with local addresses? It's quite possible that nobody
> does that, but it would be good to have someone confirm it.

I had not, but now I have. There don't appear to be any cases of that.

Rob
