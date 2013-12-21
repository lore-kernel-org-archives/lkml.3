Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3LURcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:32:09 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:20771 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3LURcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:32:07 -0500
Date: Sat, 21 Dec 2013 18:30:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Anthony Olech <anthony.olech.opensource@diasemi.com>,
        lm-sensors@lm-sensors.org, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052  power driver
Message-ID: <20131221183037.2ad91f86@endymion.delvare>
In-Reply-To: <20131219181049.GA6854@roeck-us.net>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
	<20131218163234.714a166c@endymion.delvare>
	<24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
	<20131218172402.GA18892@roeck-us.net>
	<24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>
	<20131219155454.40100f4d@endymion.delvare>
	<20131219181049.GA6854@roeck-us.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, hi Anthony,

On Thu, 19 Dec 2013 10:10:49 -0800, Guenter Roeck wrote:
> On Thu, Dec 19, 2013 at 03:54:54PM +0100, Jean Delvare wrote:
> > BTW, you (and we) probably shouldn't waste too much energy on this.
> > ADCs are only accurate to some degree anyway. If you take the
> > components connected to the input into consideration, the accuracy gets
> > even worse. For example, if the input voltage must be scaled down to
> > fit in the ADC's range, you need at least one resistor, which in best
> > cases will have a 1% accurate value (known as tolerance.) That's ten
> > times the LSB of your 10-bit ADC, at which point / 1023 or / 1024
> > really makes no practical difference. Sub-percent tolerant resistors are
> > expensive and rare in consumer electronics in my experience.
>
> True, but on the other side (and after looking into the datasheet)
> the driver already calculated the voltage on adc4..6 correctly,
> so unless you disagree I would like to apply the hwmon patch to -next
> for consistency.

The datasheet isn't the best quality I've seen. The gain values
mentioned to not even match the formulas in the same cell... But I can't
object to implementing conversions the way the datasheet says, no
matter how suspicious.

I don't really know what tree the patch is based on. Anthony said
linux-next but I can't see ichg_reg_to_mA there.

If volt_reg_to_mv is updated then you certainly want to update
vbbat_reg_to_mv the same way, as it diverges from the datasheet just
the same.

Also, please update Documentation/hwmon/da9052 so that the
documentation matches the actual driver code.

I really would like to hear what David Dajun Chen has to say about
that. He must have had a reason to use different conversions formulas
than the datasheet specifies.

-- 
Jean Delvare
