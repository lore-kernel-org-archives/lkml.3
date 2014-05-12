Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbaELQsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:48:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaELQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:48:09 -0400
Date: Mon, 12 May 2014 18:48:06 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
Message-ID: <20140512184806.63ce37b0@endymion.delvare>
In-Reply-To: <20140512155931.GB29066@roeck-us.net>
References: <20140511130023.GA501@dashie>
	<536FFC55.2080009@roeck-us.net>
	<20140512081051.29333503@endymion.delvare>
	<20140512155931.GB29066@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, 12 May 2014 08:59:31 -0700, Guenter Roeck wrote:
> I only see the adt7462 driver scanning for 0x5c. Guess I'll accept the
> address for now; I don't see a good reason not to.

sensors-detect also scans it for the SMSC EMC1072, EMC1073 and EMC1074
which we don't support yet. I have no objection to scanning it.

> Couple of other questions:
> - would it make sense to relax store_hyst to not return ERANGE but use clamp_val
>   instead ?

Yes, I had exactly the same thought when reading the code this morning.

> - Currently hyst can be stored for all crit attributes even though there is only
>   one hyst register. Should we change this to only support writing it for
>   temp1_crit_hyst ?

Yes, that would align this driver with what other drivers do.

> - I might convert the driver to use regmap if I find the time. Do you have any
>   concerns with that ?

I know nothing about regmap, so no objection, I simply don't care ;-)

-- 
Jean Delvare
SUSE L3 Support
