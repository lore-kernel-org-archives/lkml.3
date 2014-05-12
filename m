Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaELGK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:10:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaELGKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:10:55 -0400
Date: Mon, 12 May 2014 08:10:51 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
Message-ID: <20140512081051.29333503@endymion.delvare>
In-Reply-To: <536FFC55.2080009@roeck-us.net>
References: <20140511130023.GA501@dashie>
	<536FFC55.2080009@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, Josef,

On Sun, 11 May 2014 15:40:21 -0700, Guenter Roeck wrote:
> On 05/11/2014 06:00 AM, Josef Gajdusek wrote:
> > @@ -366,14 +433,19 @@ static int emc1403_probe(struct i2c_client *client,
> >   }
> >
> >   static const unsigned short emc1403_address_list[] = {
> > -	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
> > +	/* emc1403/emc1404/emc1423/emc1424 */
> > +	0x4c, 0x4d, 0x18, 0x29,
> > +	/* emc1412 */
> > +	0x5c, 0x4c, 0x6c, 0x1c, 0x3c, I2C_CLIENT_END
> 
> No duplication of addresses, and addresses are by convention in order.
> Jean, any addresses which should not be scanned ?

0x3c and 0x6c should indeed not be scanned, sensors-detect does not
scan them as they aren't typically used by hwmon devices. 0x5c is
questionable (currently scanned, but used only by a limited number of
chips, we may drop it at some point.) 0x1c and 0x4c are OK to scan.

-- 
Jean Delvare
SUSE L3 Support
