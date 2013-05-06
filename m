Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3EFHoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:44:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29783 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3EFHoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:44:19 -0400
Date: Mon, 6 May 2013 10:43:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] staging: =?utf-8?Q?ste=5Fr?=
 =?utf-8?Q?mi4=3A_Suppress_'ignoring_return_value_of_=E2=80=98regulator=5F?=
 =?utf-8?B?ZW5hYmxlKCkn?= warning
Message-ID: <20130506074323.GH4635@mwanda>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
 <20130503070713.GA27956@bnru09>
 <20130505141855.GB4686@mwanda>
 <20130506065138.GA31763@bnru10>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506065138.GA31763@bnru10>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:21:39PM +0530, Srinidhi Kasagar wrote:
> > > > -	regulator_enable(rmi4_data->regulator);
> > > > +	retval = regulator_enable(rmi4_data->regulator);
> > > > +	if (retval < 0)
> > > > +		return retval;
> > > Does it make sense to add a dev_err?
> > > 
> > 
> > Is that a question?
> > 
> > regulator_enable() already prints some warnings.  Probably it's not
> > going to fail and adding code that is duplicative or will never be
> > run is pointless.
> 
> It has become a habit checking the return value and spit some errors.
> And BTW, there are many drivers which does this way..Anyway if your
> intention is to avoid them for the new drivers..I dont mind skipping
> this..

It's not like I'm trying to ban error messages.  There isn't any
official policy on error messages.

regards,
dan carpenter

