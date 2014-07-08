Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaGHIYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:24:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:28047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbaGHIYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="454365612"
Message-ID: <1404807878.5102.85.camel@smile.fi.intel.com>
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Jul 2014 11:24:38 +0300
In-Reply-To: <1404751810.27043.90.camel@joe-AO725>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404751810.27043.90.camel@joe-AO725>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 09:50 -0700, Joe Perches wrote:
> On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:
> 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> >  static noinline_for_stack
> > +char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> > +		     const char *fmt)
> []
> > +	if (spec.field_width == 0)
> > +		/* nothing to print */
> > +		return buf;
> []
> > +	len = spec.field_width < 0 ? 1 : spec.field_width;
> 
> If field_width is not specified, emit a single byte?

A single byte to be escaped (it might be \000, for example, on output).

> Perhaps better if -1 was accepted by string_escape_mem
> as a strlen request or just ignored as a 0 length is
> above.

Would it be any benefit here?

> fyi: hex_string emits nothing on printk("%ph", buf);

Works just fine. How did you check it?

pr_info("%ph\n", in); => test_string_helpers: 1b

(I suppose "\n" flushes a buffer for me.)

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

