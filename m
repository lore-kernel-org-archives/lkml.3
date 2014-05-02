Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaEBWXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:23:00 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36896 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaEBWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <535A7E49.8000809@wwwdotorg.org>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
	<1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
	<CACRpkdadAUXgC-K6be6SFFn2ZTvCqkTK7VRJEzpFdUbybKc3YA@mail.gmail.com>
	<CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com>
	<20140424182243.GA27443@ulmo>
	<535A7E49.8000809@wwwdotorg.org>
Date: Fri, 2 May 2014 15:22:58 -0700
Message-ID: <CACRpkdYtuQDFZxf5FhY4Dc9CQka=wMZwEETBks450zVK0rEL3w@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 8:24 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/24/2014 12:22 PM, Thierry Reding wrote:
> ...
>> The downside of not allowing the gpiod API to support the -gpio suffix
>> is that we'll never be able to convert drivers that use such a binding
>> and will forever have a hodgepodge of GPIO APIs that we need to support.
>
> Perhaps rather than making the existing gpiod API automatically search
> for both -gpios and -gpio, we could make a new API for the other suffix,
> so that driver indicate explicitly which property name they want. That
> way, someone can't accidentally write -gpio in the DT and have it still
> work. Or, add a parameter to the existing API, but that's probably a lot
> more churn.

Hm, that is possible, I just worry that this will lead the DT and ACPI
semantics to diverge even more, and the present patch make things
more coherent from the framework side of things instead of even more
elaborate per-HW-info-method :-/

Yours,
Linus Walleij
