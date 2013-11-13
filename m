Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab3KMOdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:33:08 -0500
Received: from mail-de.keymile.com ([195.8.104.250]:35039 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab3KMOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:33:06 -0500
Message-ID: <52838D9C.80500@keymile.com>
Date: Wed, 13 Nov 2013 15:33:00 +0100
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] spi: spi-gpio: Add check for cs-gpios dt property
References: <1384329748-2897-1-git-send-email-gerlando.falauto@keymile.com> <20131113133320.GL878@sirena.org.uk>
In-Reply-To: <20131113133320.GL878@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 11/13/2013 02:33 PM, Mark Brown wrote:
> On Wed, Nov 13, 2013 at 09:02:28AM +0100, Gerlando Falauto wrote:
>> The bindings assumed that the cs-gpios property is always there.
>> However, a single SPI device can also work fine without an explicit chip select.
>> Use the SPI_GPIO_NO_CHIPSELECT mode when the property is not present or invaild.
>
> Given that for most systems a missing /CS would be an error it seems
> better to add an explicit property to enable this in order to help make
> problems with the more common case more obvious.
>

Thank you for your answer.
How about an empty

	cs-gpios;

property? To explicitly state we haven't just forgotten it -- we just 
know we don't have one instead. (There are plenty of empty "ranges;" 
properties in ARM DTSes -- I don't know if the use case is the same though).

Or else a null-valued

	cs-gpios = <0>;

property?

I'm open to other proposals of course.

Thanks again!
Gerlando
