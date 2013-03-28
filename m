Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3C1GSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:18:10 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:53223 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3C1GSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:18:08 -0400
Message-ID: <1364451516.15039.11.camel@gitbox>
Subject: Re: [PATCH] pinctrl: bcm2835: make use of
 of_property_read_u32_index()
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 19:18:36 +1300
In-Reply-To: <1364447397-29005-1-git-send-email-swarren@wwwdotorg.org>
References: <1364447397-29005-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 23:09 -0600, Stephen Warren wrote:
> Use the new standard API of_property_read_u32_index() instead of open-
> coding it.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> Note: This depends on the proposed patch "of: Add support for reading
> a u32 from a multi-value property" by Tony Prisk.
> 
> BTW, I realized why I didn't create that standard API, but wrote custom
> prop_u32() instead; the code has already looked up the properties, and
> validated their length, so prop_u32() can simply index into the property
> data, whereas of_property_read_u32_index() needs to go search for the
> property and re-validate it every time, so there's a bunch more overhead.
> It also means duplicating the property name, although I could use a
> define for that. I'm not entirely convinced that using this standard API
> is a win in this case. LinusW, Tony, what do you think?
> ---

When I was writing the function I had a similar thought about the fact
we need to work out the length first, which as you mentioned, requires
all the prior work on the property anyway.

I didn't bring it up, because I thought someone might say 'hey, you
should add a function to get the count as well' :)

In both the brcm and vt8500 use cases, we will have the issue of
multiple lookups on the same property using 'generic' functions. Price
we have to pay for generic code?

Regards
Tony P

