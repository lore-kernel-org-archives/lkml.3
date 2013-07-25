Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3GYNVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:21:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58181 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3GYNVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130725131556.GD9858@sirena.org.uk>
References: <1624911.6TtmtVmU1T@avalon>
	<CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
	<1408178.cxAUTUGJc5@avalon>
	<20130725131556.GD9858@sirena.org.uk>
Date: Thu, 25 Jul 2013 15:21:35 +0200
Message-ID: <CACRpkdY-mdLbMY16aMqR9Jwu8qs9q4KNyxOxnwhXiGrAAxpKjg@mail.gmail.com>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control
 its IRQ domain ?
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 3:15 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 25, 2013 at 11:45:33AM +0200, Laurent Pinchart wrote:
>
>> The number of interrupts can be pretty high (up to 58 in the worst case so
>> far), so an alternative would be to specify the interrupt-parent only, and
>> call irq_create_of_mapping() directly. What solution would you prefer ?
>
> Are the interrupts in a contiguous block in the controller so you can
> just pass around the controller and a base number?

That works with platform data and in-kernel structures, but AFAICT
device tree has no such "bulk" concept but expects you to list
each and every line individually in cases like this.

Yours,
Linus Walleij
