Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJPJfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:35:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJPJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:35:20 -0400
Date: Thu, 16 Oct 2014 11:34:14 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, johannes.thumshirn@men.de
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141016093414.GA25214@kroah.com>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016085835.GA1273@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016085835.GA1273@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:58:35AM +0200, Wolfram Sang wrote:
> > +struct eeprom_data {
> > +	uint8_t eeprod_id;
> > +
> > +	uint8_t revision[3];
> > +	uint32_t serialnr;
> > +	uint8_t board_model;
> > +	char hw_name[6];
> > +
> > +	uint8_t reserved;
> > +
> > +	__be16 prod_date;
> > +	__be16 rep_date;
> > +
> > +	uint8_t reserved2[4];
> > +};
> 
> And what if the compiler reorders?

It's not allowed to reorder, but it can add padding wherever it wants
to, which if this is a on-device structure, can cause problems.  Use
__packed to prevent that.

thanks,

greg k-h
