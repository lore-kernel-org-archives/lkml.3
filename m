Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaGHIuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:50:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:4348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaGHIuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="454374346"
Message-ID: <1404809400.5102.90.camel@smile.fi.intel.com>
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Jul 2014 11:50:00 +0300
In-Reply-To: <1404750357.27043.78.camel@joe-AO725>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404750357.27043.78.camel@joe-AO725>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 09:25 -0700, Joe Perches wrote:
> [trivial notes]

Thanks! Fixed locally, though am waiting for few more days if any other
comment comes.

> 
> On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:
> > This allows user to print a given buffer as esaped string. The rules applied
> 
> as an escaped
> 
> > accordingly to the mix of the flags provided by additional format letters.
> 
> rules are applied according to an optional mix of flags
> 
> > For example, if the given buffer:
> > 
> > 	1b 62 20 5c 43 07 22 90 0d 5d
> > 
> > The result strings could be:
> 
> would be
> 
> > 	%*pE            "\eb \C\a"\220\r]"
> 
> Maybe say something about ssid's here.

Mentioned in the printk-formats.txt part.

> or maybe add an %*pES just for the ssid type.

I gave a thought to it, and it seems to me we will increase complexity
of the code to get none beneficial. The SSID in most cases has a
variable-length, thus we will pass it anyway, what else could be differ
here? Default set of flags?

> 
> > diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> []
> > @@ -70,6 +70,34 @@ DMA addresses types dma_addr_t:
> >  	For printing a dma_addr_t type which can vary based on build options,
> >  	regardless of the width of the CPU data path. Passed by reference.
> >  
> > +Raw buffer as an escaped string:
> > +
> > +	%*pE[achnops]
> > +
> > +	For printing raw buffer as an escaped string. For the following buffer
> > +
> > +		1b 62 20 5c 43 07 22 90 0d 5d
> > +
> > +	few examples show how the conversion could be done (the result string
> > +	without embraced quotes):
> 
> 'embraced' is a bit of an awkward word choice.  Maybe surrounding.
> 
> > +
> > +		%*pE		"\eb \C\a"\220\r]"
> 
> Oh, the initial commit log comments above are really for this block

Phrasing is a bit different, though I rephrased above sentence.

> 
> > +		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
> > +		%*pEa		"\e\142\040\\\103\a\042\220\r\135"
> > +
> > +	The converion rules are defined by combination of the following flags
> 
> conversion
> 
> > +	(see string_escape_mem() kernel documentation for the details):
> > +		a - ESCAPE_ANY
> > +		c - ESCAPE_SPECIAL
> > +		h - ESCAPE_HEX
> > +		n - ESCAPE_NULL
> > +		o - ESCAPE_OCTAL
> > +		p - ESCAPE_NP
> > +		s - ESCAPE_SPACE
> > +	By default ESCAPE_ANY_NP is used.
> > +
> > +	If field width is ommited the 1 byte only will be escaped.
> 
> omitted
> 
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

