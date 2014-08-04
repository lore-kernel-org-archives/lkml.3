Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaHDIq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:46:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaHDIq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:46:28 -0400
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
In-Reply-To: <53DE650E.4060909@gmail.com>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	 <1406901650-20841-4-git-send-email-kreijack@inwind.it>
	 <20140803161223.0b26e4bc@endymion.delvare>	<53DE5179.3080402@gmail.com>
	 <20140803175222.3433b646@endymion.delvare>  <53DE650E.4060909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 04 Aug 2014 10:46:26 +0200
Message-ID: <1407141986.4302.10.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sunday 03 August 2014 à 18:36 +0200, Goffredo Baroncelli a écrit :
> On 08/03/2014 05:52 PM, Jean Delvare wrote:
> > On Sun, 03 Aug 2014 17:12:57 +0200, Goffredo Baroncelli wrote:
> >> On 08/03/2014 04:12 PM, Jean Delvare wrote:
> >>>> +	    (verbose > 0 && level >= 0)) {
> >>>> +		print_temp("CPU-temp: ", temp );
> >>>> +		if (casetemp)
> >>>> +			print_temp(", Case: ", casetemp );
> >>>> +		if (level >= 0)
> >>>> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
> >>>> +				x.fan_level-level );
> >>>> +		else
> >>>> +			printk(", Fan: %d (tuned +0)\n",x.fan_level);
> >>>
> >>> I think you can do without the "tuned +0" which doesn't add much value.
> >>
> >> Me too. But the old driver does the same, so I preferred to 
> >> leave it as is.
> > 
> > I looked at the code again and no, I can't see the old code doing that.
> > It has "tuned %+d" only in tune_fan() which is only called if
> > level >= 0. The other printk (when tune_fan isn't called) doesn't have
> > a "tuned" part.
>
> This is taken from an old log of a v3.2 kernel (no changes here):
> 
> [  886.510879] CPU-temp: 55.4 C, Case: 33.1 C,  Fan: 0 (tuned -11)
> [  910.522869] CPU-temp: 56.0 C, Case: 33.5 C,  Fan: 0 (tuned +0)
> [  958.546880] CPU-temp: 57.0 C, Case: 34.1 C,  Fan: 3 (tuned +3)
> 
> in the code if level <0, then there is no update in the log. But if
> level >0 and level is equal to the previous one, this leads to
> have "tuned +0"...

I agree with that.

> But I have to be honest: I have not fully understand how 
> "level" is computed.

I agree with that too :/

> The printk without "(tuned %+d)" is never called because 
> LOG_TEMP was #define(d) equal to 0.

And this is what your second printk is replacing. So it should not have
the "(tuned *)" either.

-- 
Jean Delvare
SUSE L3 Support

