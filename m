Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaDYPaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:30:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54570 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaDYPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:30:18 -0400
Message-ID: <535A7E49.8000809@wwwdotorg.org>
Date: Fri, 25 Apr 2014 09:24:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robherring2@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com> <1398266889-17489-2-git-send-email-thierry.reding@gmail.com> <CACRpkdadAUXgC-K6be6SFFn2ZTvCqkTK7VRJEzpFdUbybKc3YA@mail.gmail.com> <CAL_Jsq+DwCBLoNYsgHnoLQgSMnSBDM5XH_xoWS-RWdmx-JBeXg@mail.gmail.com> <20140424182243.GA27443@ulmo>
In-Reply-To: <20140424182243.GA27443@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 12:22 PM, Thierry Reding wrote:
...
> The downside of not allowing the gpiod API to support the -gpio suffix
> is that we'll never be able to convert drivers that use such a binding
> and will forever have a hodgepodge of GPIO APIs that we need to support.

Perhaps rather than making the existing gpiod API automatically search
for both -gpios and -gpio, we could make a new API for the other suffix,
so that driver indicate explicitly which property name they want. That
way, someone can't accidentally write -gpio in the DT and have it still
work. Or, add a parameter to the existing API, but that's probably a lot
more churn.

