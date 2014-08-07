Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaHGVFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:05:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:05:38 -0400
Date: Thu, 7 Aug 2014 23:05:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: joeyli <jlee@suse.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Takashi Iwai <tiwai@suse.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Hibernate: check unsafe page should not in e820
 reserved region
Message-ID: <20140807210532.GA7816@Nokia-N900>
References: <1407165801-24648-1-git-send-email-jlee@suse.com>
 <20140807040543.GE26210@linux-rxt1.site>
 <20140807080025.GA24700@amd.pavel.ucw.cz>
 <20140807085203.GF26210@linux-rxt1.site>
 <20140807093957.GB28649@Nokia-N900>
 <20140807101734.GG26210@linux-rxt1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807101734.GG26210@linux-rxt1.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-08-07 18:17:34, joeyli wrote:
> On Thu, Aug 07, 2014 at 11:39:57AM +0200, Pavel Machek wrote:
> > > > Actually, if you are doing such a check... it makes sense to check for
> > > > _all_ the regions, nosave or not. If e820 map changed at all, it is
> > > > not safe to resume.
> > > > 									Pavel
> > > 
> > > Currently nosave region only called register by e820 code, so hibernate's nosave region included e820
> > > reserved, ACPI data and ACPI NVS region.
> > > 
> > > I thought hashing the start/end pfn of above regions is enough.
> > 
> > If ammount of memory changed, for example, it is unsafe to
> > resume. So if you are doing the check, anyway, please hash
> > whole e820 table.
> 
> There already have num_physpages in header for check the total physical page number.

Good, but if ammount of memory stayed the same, but offsets
changed (for example), resume is unsafe, too.

When I wrote that num_physpages check, I should have checked
whole e820  table, instead. (If anything at all changed there,
"new" kernel is running with wrong e820 info).

You seem to be in great position to fix that mistake now...

						Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
