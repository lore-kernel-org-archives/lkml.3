Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaEZNmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:42:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:18632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaEZNmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="scan'208";a="436951925"
Date: Mon, 26 May 2014 16:42:34 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ACPI / LPSS: custom power domain for LPSS
Message-ID: <20140526134234.GA12107@xps8300>
References: <20140523130252.GH18308@xps8300>
 <1400850909-12146-1-git-send-email-heikki.krogerus@linux.intel.com>
 <11413734.64aCNVobNb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11413734.64aCNVobNb@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 03:03:27PM +0200, Rafael J. Wysocki wrote:
> On Friday, May 23, 2014 04:15:09 PM Heikki Krogerus wrote:
> > A power domain where we save the context of the additional
> > LPSS registers. We need to do this or all LPSS devices are
> > left in reset state when resuming from D3 on some Baytrails.
> > The devices with the fractional clock divider also have
> > zeros for N and M values after resuming unless they are
> > reset.
> > 
> > Li Aubrey found the root cause for the issue. The idea of
> > using power domain for LPSS came from Mika Westerberg.
> > 
> > Reported-by: Jin Yao <yao.jin@linux.intel.com>
> > Suggested-by: Li Aubrey <aubrey.li@linux.intel.com>
> > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> Queued up for 3.16, but I needed to rebase it to take some other changes
> into account.  Can you please have a look and the bleeding-edge branch in
> my tree and see if everything looks good in there?

I checked the bleeding-edge and it looks good to me. Thanks for taking
care of the issue with "%lx".

About the sparse warning from the clk-fractional-divider.c. Since
there is no real issue, let's follow the style in the other clock
types and ignore the warning. So let's keep that patch as it is. OK?



-- 
heikki
