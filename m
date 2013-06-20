Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3FTSSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:18:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52314 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758593Ab3FTSSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:18:45 -0400
Message-ID: <1371752324.2146.25.camel@joe-AO722>
Subject: Re: Re: [PATCH] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip
 GPIO pins.
From: Joe Perches <joe@perches.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        David Daney <david.daney@cavium.com>
Date: Thu, 20 Jun 2013 11:18:44 -0700
In-Reply-To: <51C34584.8070301@gmail.com>
References: <1371251915-18271-1-git-send-email-ddaney.cavm@gmail.com>
	 <CACRpkdYHzBBbPNujYRGkMFGuQRzeYKs9jgfc3e3HWyxQFahvRQ@mail.gmail.com>
	 <51C34584.8070301@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 11:10 -0700, David Daney wrote:
> Sorry for not responding earlier, but my e-mail system seems to have 
> malfunctioned with respect to this message...
[]
> On 06/17/2013 01:51 AM, Linus Walleij wrote:
> >> +static int octeon_gpio_get(struct gpio_chip *chip, unsigned offset)
> >> +{
> >> +       struct octeon_gpio *gpio = container_of(chip, struct octeon_gpio, chip);
> >> +       u64 read_bits = cvmx_read_csr(gpio->register_base + RX_DAT);
> >> +
> >> +       return ((1ull << offset) & read_bits) != 0;
> >
> > A common idiom we use for this is:
> >
> > return !!(read_bits & (1ull << offset));
> 
> I hate that idiom, but if its use is a condition of accepting the patch, 
> I will change it.

Or use an even more common idiom and change the
function to return bool and let the compiler do it.


