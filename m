Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaE0JBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:01:44 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39098 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaE0JBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLK6TcGBtiVWFui9NunantvqNUqCmJErsFLN8DeC3C3nw@mail.gmail.com>
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
	<CAAVeFuLK6TcGBtiVWFui9NunantvqNUqCmJErsFLN8DeC3C3nw@mail.gmail.com>
Date: Tue, 27 May 2014 11:01:40 +0200
Message-ID: <CACRpkdbVFT23h-BCpshE9w-eK5+sdXHB_utzxAffO+iUs9cPBA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 4:37 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Thu, May 15, 2014 at 12:44 AM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:

>> +static void __crystalcove_irq_type(int gpio, int type)
>> +{
>> +       u8 ctli = gpio < 8 ? GPIO0P0CTLI + gpio : GPIO1P0CTLI + (gpio - 8);
>
> Not a big comment, but wouldn't it be safer to factorize this logic
> (which is repeated in many places) into some macro? e.g. something
> like:
>
> #define GPIOP0CTL(gpio, dir) ((gpio < 8 ? GPIO0P0CTL ## dir :
> GPIO1P0CTL ## dir) + (gpio & ~0x8))

static functions are preferred over macros, please :-)

If you want to be sure they are inlined, just mark them inline (but the
compiler will do it's job for sure).

Just split the function instead so it is more readable:

static void __crystalcove_irq_type(int gpio, int type)
{
      u8 ctli;

      if (gpio < 8)
                ctli = GPIO0P0CTLI + gpio;
      else
                ctli = GPIO1P0CTLI + (gpio - 8);

But I think this can be simplified with the % operator as stated
elsewhere.

Yours,
Linus Walleij
