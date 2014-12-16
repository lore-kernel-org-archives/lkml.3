Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaLPNz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:55:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLPNz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:55:26 -0500
Date: Tue, 16 Dec 2014 16:54:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Rorvick <chris@rorvick.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Donald <gdonald@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not specified
Message-ID: <20141216135459.GJ4856@mwanda>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
 <20141216094109.GH4856@mwanda>
 <D0B55F56.D05F1%andreas.dilger@intel.com>
 <20141216113509.GI4856@mwanda>
 <CAEUsAPYTBq+0DGG909Rn0JhpF5Rh_6KbvmxS0wPQJ3j+qgZrEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEUsAPYTBq+0DGG909Rn0JhpF5Rh_6KbvmxS0wPQJ3j+qgZrEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 06:53:19AM -0600, Chris Rorvick wrote:
> On Tue, Dec 16, 2014 at 5:35 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Dec 16, 2014 at 11:14:35AM +0000, Dilger, Andreas wrote:
> > >
> > > Sorry, that isn't right.  Chris' patch is actually doing the right thing
> > > to check for units > 1.
> >
> > It's not right because it discards the negative.
> 
> I don't think this patch introduces a bug.  If anything, it was already
> there.

The original code may be totally buggy.  Who knows?  Why are we passing
negative numbers here anyway instead of just returning -EINVAL?  But the
new code is also buggy and not consistent with itself.

In the original code if the user data is "-1k" or "-1024" that was
treated the same.  In the new code, "-1k" means negative 1024 because
the user supplies units but "-1024" means positive 1024 because there
are no units given.

> > >  The proposed change above discards "mult"
> > > entirely, which breaks the users of this function that are not in this
> > > file (e.g. osc_cached_mb_seq_write() or ll_max_cached_mb_seq_write())
> > > that have tunables in units of MB by default, but can also use parameters
> > > with units like "4.5G" for convenience.
> >
> > I think you are confusing lprocfs_write_frac_helper() and
> > lprocfs_write_frac_u64_helper().  There is only one caller for this
> > function.
> 
> By this logic, lprocfs_write_frac_u64_helper() should just be removed
> and it's code should be folded into lprocfs_write_u64_helper(), no?
> 

There are vast swathes of lustre code which need to be deleted but I
haven't looked at this one.  Probably.

regards,
dan carpenter

