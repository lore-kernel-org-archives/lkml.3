Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbaGCKtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:49:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:61621 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaGCKtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,594,1400050800"; 
   d="scan'208";a="564660525"
Message-ID: <1404384546.5102.71.camel@smile.fi.intel.com>
Subject: Re: [PATCH 3/6] lib80211: re-use string_escape_mem_any_np()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 03 Jul 2014 13:49:06 +0300
In-Reply-To: <1404318611.14624.80.camel@joe-AO725>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404308611.14624.78.camel@joe-AO725>
	 <1404309961.5102.35.camel@smile.fi.intel.com>
	 <1404318611.14624.80.camel@joe-AO725>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 09:30 -0700, Joe Perches wrote:
> On Wed, 2014-07-02 at 17:06 +0300, Andy Shevchenko wrote:
> > On Wed, 2014-07-02 at 06:43 -0700, Joe Perches wrote:
> > > On Wed, 2014-07-02 at 16:20 +0300, Andy Shevchenko wrote:
> > > > In kernel we have function to escape a given string. Let's use it instead of
> > > > custom approach.
> > > > 
> > > > This fixes a bug. The current implementation wrongly prints octal numbers: only
> > > > two first digits are used in case when 3 are required and the rest of the
> > > > string ends up cut off.
> > 
> > []
> > 
> > > This code looks like it was adapted from the old print_mac
> > > ethernet code that was eventually replaced by a vsprintf
> > > pointer extension %pM
> > > 
> > > So a better way to do this might be to add and use yet
> > > another vsprintf %p<foo> extension for ssids.
> > 
> > Might be, but it
> >  - doesn't reduce necessity of string_escape_mem (not only ssid are
> > escaped in kernel)
> >  - prevents user to choose a rule what exactly their would like to
> > escape (look at the other patches against ssid escaping)
> > 
> 
> %pE<FLAGS> would allow the same arbitrary combinations
> of your flags.

Makes sense. 
Can do this as a separate patch.
Though I would have a sane default for escaping SSIDs. I hope that one
from print_ssid() could be the one.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

