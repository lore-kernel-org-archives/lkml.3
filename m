Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3EVOlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:41:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55155 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3EVOlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:41:24 -0400
Date: Wed, 22 May 2013 15:40:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: nsekhar@ti.com, khilman@deeprootsystems.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] gpio: davinci: coding style correction
Message-ID: <20130522144042.GG18614@n2100.arm.linux.org.uk>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:40:25PM +0530, Philip Avinash wrote:
>  /*
>   * Assuming the pin is muxed as a gpio output, set its output value.
>   */
> -static void
> -davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
> +		int value)

This kind of stuff is just churn.  If you read Documentation/CodingStyle:

Statements longer than 80 columns will be broken into sensible chunks, unless
exceeding 80 columns significantly increases readability and does not hide
information. Descendants are always substantially shorter than the parent and
are placed substantially to the right. The same applies to function headers
with a long argument list. However, never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.

"broken into sensible chunks".  Here's the question: is the former a
sensible format?  Arguably it is because it results in all the arguments
fitting on one line at the expense of missing the return value.

The latter is also a sensible format - but breaks the arguments instead
of the return value.

Both formats can be found in their entirety by grep by function name alone:

	grep -1 davinci_gpio_set

or if you prefer to type some more then you end up with more specific

	grep -A1 davinci_gpio_set
or
	grep -B1 davinci_gpio_set

depending on the version.

Where there's no clear advantage one way or the other, let the authors
preference stand.
