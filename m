Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3AOHCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:02:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53803 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab3AOHCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:02:50 -0500
Date: Tue, 15 Jan 2013 16:02:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: "andrey.smirnov@convergeddevices.net" 
	<andrey.smirnov@convergeddevices.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [regmap] [RESEND] Add "no-bus" option for regmap API
Message-ID: <20130115070243.GF5701@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
 <1358024054-9895-4-git-send-email-andrew.smirnov@gmail.com>
 <20130113231836.GJ5041@opensource.wolfsonmicro.com>
 <CAHQ1cqGWYsfBAsp_8AOyJ0Q-7_PS-v6wRv6w5DQTju5tNf9fdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGWYsfBAsp_8AOyJ0Q-7_PS-v6wRv6w5DQTju5tNf9fdg@mail.gmail.com>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 09:08:27AM -0800, Andrey Smirnov wrote:
> On Sun, Jan 13, 2013 at 3:18 PM, Mark Brown
> > On Sat, Jan 12, 2013 at 12:54:14PM -0800, Andrey Smirnov wrote:

> >> +     bool cache_registers;

> > I'm afraid I don't quite understand this...

> From my understanding of the code it is done because the caching is
> handled differently for cases when format_write() and format_reg(),
> format_val() are provided.

> In case of 'format_write' the regcache_write() is called in
> _regmap_write() directly whereas when format_reg(), format_val() are
> there _regmap_write() calls _regmap_raw_write() which in turn calls
> regcache_write(). If I remove that variable and corresponding check
> then regcache_write() would be called twice in the case of
> format_reg(), format_val(), when _regmap_write() is called, would it
> not? I apologise if I miss something obvious and that is not a case(or
> issue).

OK, in this case the variable is confusingly named - it has no effect on
if we're going to cache, it's about where we cache.  What's really
driving the decision here is a combination of having block I/O support
(this was done this way to support cache for block writes) and having
the ability to read (which is what limits us).  Not sure I can think of
a good name right now though...
