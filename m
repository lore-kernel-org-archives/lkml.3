Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaGGOEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:04:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaGGOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:04:43 -0400
Date: Mon, 7 Jul 2014 16:04:40 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] i2c: stub: Add support for SMBus block commands
Message-ID: <20140707160440.042fda11@endymion.delvare>
In-Reply-To: <53BAA152.9040002@roeck-us.net>
References: <1404705312-27633-1-git-send-email-linux@roeck-us.net>
	<20140707102711.1b630fe2@endymion.delvare>
	<53BAA152.9040002@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2014 06:32:02 -0700, Guenter Roeck wrote:
> On 07/07/2014 01:27 AM, Jean Delvare wrote:
> > On Sun,  6 Jul 2014 20:55:12 -0700, Guenter Roeck wrote:
> >>   			chip->words[command] &= 0xff00;
> >>   			chip->words[command] |= data->byte;
> >>   			dev_dbg(&adap->dev,
> >>   				"smbus byte data - addr 0x%02x, wrote 0x%02x at 0x%02x.\n",
> >>   				addr, data->byte, command);
> >>   		} else {
> >> -			data->byte = chip->words[command] & 0xff;
> >> +			if (b)
> >> +				data->byte = b->len;
> >> +			else
> >> +				data->byte = chip->words[command] & 0xff;
> >
> > You could avoid this conditional (and the same below in case
> > I2C_SMBUS_WORD_DATA) by writing to chip->words at the same time you
> > write to b->block. Block transfers being rare and reads occurring more
> > frequently than writes, I think the performance benefit is clear.
>
> Makes sense, I'll do that. Great idea.
> 
> Question is if I should cover attempts to write a byte or word into block data.
> I don't think it is worth the effort, as drivers won't usually do that.
> My take is that we could add it later if really needed.
> What do you think ?

I agree. The i2c-stub driver can't possibly cover every use case
anyway, so let's keep it simple and only emulate behaviors we need for
real.

-- 
Jean Delvare
SUSE L3 Support
