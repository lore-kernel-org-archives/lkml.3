Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3IXMUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:20:47 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37471 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130923202935.GA5216@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-3-git-send-email-treding@nvidia.com>
	<CACRpkdYo8knzZ+Z-tc7fyEGwX5bt4RvMU3TR3k3UrOj0KRJocw@mail.gmail.com>
	<20130923202935.GA5216@ulmo>
Date: Tue, 24 Sep 2013 14:20:44 +0200
Message-ID: <CACRpkdZMM9RUkRCWG0mYbF9PL-fOdDncpY05xG3F5BF55hn5ug@mail.gmail.com>
Subject: Re: [PATCH 2/9] irqdomain: Introduce __irq_create_mapping()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:29 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Sep 23, 2013 at 09:14:30PM +0200, Linus Walleij wrote:

>> I think it is better to first go over the call sites and make them
>> all handle negative return numbers rather than pushing the
>> obscure __interface.
(...)
>
> Well, the problem is that the current patch changes the signature of the
> function as well, therefore the call sites will have to be updated all
> at once in a single patch to avoid build breakage.

Hm yeah OK I see the problem, but can we atleast avoid the
__thing? Like calling the new function irq_create_mapping_strict()
or whatever.

> Another alternative could be to change the signature in a way that does
> not break compatibility. For instance I think it could work out if we
> change this function to return int instead of unsigned int but keep the
> same semantics to begin with (return 0 on failure). Then update all call
> sites to handle potential negative errors and after that return negative
> error codes.

Hm that sounds like an attractive solution to me actually.

> That still wouldn't catch any callers introduced between
> the patch creation and application.

Such things happen all the time, just have to be attentive in
what goes into linux-next...

Another minor thing:

+static int __irq_create_mapping(struct irq_domain *domain,
+                               irq_hw_number_t hwirq, unsigned int *virqp)

Unless you can make a very good case for why there should
be a "v" in the beginning of virqp, then remove it and call it
"irqp" simply.

All Linux IRQs are virtual and we're already clearly separating
out those that are not by calling them "hwirq".

Yours,
Linus Walleij
