Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3DAWJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:09:50 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:51436 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab3DAWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:09:47 -0400
Date: Tue, 2 Apr 2013 01:09:42 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, tony@atomide.com,
        juha.yrjola@solidboot.com, linux@arm.linux.org.uk, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130401220942.GB18196@blackmetal.musicnaut.iki.fi>
References: <2059303614.30062.1364731542427.JavaMail.apache@mail83.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2059303614.30062.1364731542427.JavaMail.apache@mail83.abv.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 31, 2013 at 03:05:42PM +0300, Ивайло Димитров wrote:
> Yep, the code looks almost identical, I guess with some tweaks all SMC
> code from that patch could be removed and instead used the one from SMC
> PPA API.
> 
> What I don't get, is why one needs to disable/enable fiqs/irqs:

[..]

> Do you have any idea why is that needed? Any other code I've ever seen
> to call SM, does not disable fiqs/irqs, is RNG SMC somehow special? I
> know this is Nokia's code, but still, if we can get some understanding...

I think without disabling irqs you may suffer some strange crashes when
heavily stressing the RNG... that's why you also have cache flushes before
and after the SMC. With proper test suite you could probably verify this.
How are you testing this driver?

A.
