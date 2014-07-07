Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaGGAw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 20:52:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:44009 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaGGAwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 20:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwd7sKSKu0+pfSOUGUQrbVuCO_ZBAXds=uGYx5=yfV=VA@mail.gmail.com>
References: <CACxGe6vFHADzsE7_69B+jjT3kwX_3kOdUBzjtSVEYETwR7HY3Q@mail.gmail.com>
 <CA+55aFwd7sKSKu0+pfSOUGUQrbVuCO_ZBAXds=uGYx5=yfV=VA@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 7 Jul 2014 01:52:33 +0100
X-Google-Sender-Auth: BMMUE1ZWX-NpfGYac3aLNwWE-nk
Message-ID: <CACxGe6sZgjVeCLW8VXAtrYg+mbZYOsUvTySJzuBp9OijiTmNyQ@mail.gmail.com>
Subject: Re: [GIT PULL] bug fix for devicetree memory parsing
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Herring <rob.herring@linaro.org>, Laura Abbott <lauraa@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 8:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jul 6, 2014 at 2:37 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>
>> Can you pull this bug fix into your tree please?
>
> I took it, but I think both your explanation and the patch itself is
> actually crap. It may fix the issue, but it's seriously confused.
>
> Your explanation says that it's a 32-bit platform issue. No it's not.
> Most 32-bit configurations still have a 64-bit phys_addr_t (ie
> PAE/LPAE etc).
>
> And the code is crap, because it uses ULONG_MAX etc in ways that
> simply make no f*cking sense. And why does it care about sizeof?
>
> Why does the code not just do something like
>
>   #define MAX_PHYS_ADDR ((phys_addr_t) ~0)
>
> and then do
>
>   if (base > MAX_PHYS_ADDR || base + size > MAX_PHYS_ADDR)
>     ...

Sure. I'll make sure a cleanup patch gets written and queued up.

g.
