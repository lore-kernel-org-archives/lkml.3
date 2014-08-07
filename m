Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaHGIwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:52:21 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:41730 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaHGIwT (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 7 Aug 2014 04:52:19 -0400
Date: Thu, 7 Aug 2014 16:52:03 +0800
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Takashi Iwai <tiwai@suse.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Hibernate: check unsafe page should not in e820
 reserved region
Message-ID: <20140807085203.GF26210@linux-rxt1.site>
References: <1407165801-24648-1-git-send-email-jlee@suse.com>
 <20140807040543.GE26210@linux-rxt1.site>
 <20140807080025.GA24700@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807080025.GA24700@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:00:25AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > When the machine doesn't well handle the e820 persistent when hibernate
> > > resuming, then it may causes page fault when writing image to snapshot
> > > buffer:
> > > 
> > > [   17.929495] BUG: unable to handle kernel paging request at ffff880069d4f000
> > > [   17.933469] IP: [<ffffffff810a1cf0>] load_image_lzo+0x810/0xe40
> > > [   17.933469] PGD 2194067 PUD 77ffff067 PMD 2197067 PTE 0
> > > [   17.933469] Oops: 0002 [#1] SMP
[...]
> > > [    8.933534] PM: Failed to load hibernation image, recovering.
> > > 
> > > v2:
> > >  + removed empty check of nosave_regions list.
> > >  + fixed the typo of "region" in code for error message and patch comment.
> > > 
> > > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > Cc: Len Brown <len.brown@intel.com>
> > > Cc: Takashi Iwai <tiwai@suse.de>
> > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > 
> > I discussed with Vojtech Pavlik for this patch, he raised a situation is:
> > 
> > Maybe e820 changed but image kernel original pages do not fall into new e820 region.
> > Then the hibernate will recovery success, but later kernel drivers may got problem
> > when accessing memory. 
> > 
> > My idea is hashing the start/end pfn of each nosave region sequentially, put this
> > nosave region digest to hibernate header then compare e820 digest in check_header()
> > when hibernate resuming.
> > 
> > I am developing patch, then we don't need check unsafe page should not in unsave(e820)
> > regions.
> 
> Actually, if you are doing such a check... it makes sense to check for
> _all_ the regions, nosave or not. If e820 map changed at all, it is
> not safe to resume.
> 									Pavel

Currently nosave region only called register by e820 code, so hibernate's nosave region included e820
reserved, ACPI data and ACPI NVS region.

I thought hashing the start/end pfn of above regions is enough.


Regards
Joey Lee
