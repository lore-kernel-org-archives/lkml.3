Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaELP7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:59:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36344 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaELP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:59:42 -0400
Date: Mon, 12 May 2014 08:59:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
Message-ID: <20140512155931.GB29066@roeck-us.net>
References: <20140511130023.GA501@dashie>
 <536FFC55.2080009@roeck-us.net>
 <20140512081051.29333503@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512081051.29333503@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 08:10:51AM +0200, Jean Delvare wrote:
> Hi Guenter, Josef,
> 
> On Sun, 11 May 2014 15:40:21 -0700, Guenter Roeck wrote:
> > On 05/11/2014 06:00 AM, Josef Gajdusek wrote:
> > > @@ -366,14 +433,19 @@ static int emc1403_probe(struct i2c_client *client,
> > >   }
> > >
> > >   static const unsigned short emc1403_address_list[] = {
> > > -	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
> > > +	/* emc1403/emc1404/emc1423/emc1424 */
> > > +	0x4c, 0x4d, 0x18, 0x29,
> > > +	/* emc1412 */
> > > +	0x5c, 0x4c, 0x6c, 0x1c, 0x3c, I2C_CLIENT_END
> > 
> > No duplication of addresses, and addresses are by convention in order.
> > Jean, any addresses which should not be scanned ?
> 
> 0x3c and 0x6c should indeed not be scanned, sensors-detect does not
> scan them as they aren't typically used by hwmon devices. 0x5c is
> questionable (currently scanned, but used only by a limited number of
> chips, we may drop it at some point.) 0x1c and 0x4c are OK to scan.
> 
Hi Jean,

I only see the adt7462 driver scanning for 0x5c. Guess I'll accept the
address for now; I don't see a good reason not to.

Couple of other questions:
- would it make sense to relax store_hyst to not return ERANGE but use clamp_val
  instead ?
- Currently hyst can be stored for all crit attributes even though there is only
  one hyst register. Should we change this to only support writing it for
  temp1_crit_hyst ?
- I might convert the driver to use regmap if I find the time. Do you have any
  concerns with that ?

Thanks,
Guenter
