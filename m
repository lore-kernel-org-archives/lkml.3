Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3KGOzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:55:40 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:51027 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KGOzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:55:37 -0500
X-Greylist: delayed 1008 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 09:55:37 EST
Date: Thu, 7 Nov 2013 15:38:32 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Bob Liu <bob.liu@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org, daniel.kiper@oracle.com
Subject: Re: [Xen-devel] [PATCH] xen/balloon: Set balloon's initial state to number of existing RAM pages
Message-ID: <20131107143832.GA27283@router-fw-old.local.net-space.pl>
References: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com> <527AE1CA.7030703@oracle.com> <7ae8615f-36f4-4c28-a147-c522335ba8f7@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae8615f-36f4-4c28-a147-c522335ba8f7@email.android.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 08:25:04PM -0500, Konrad Rzeszutek Wilk wrote:
> Bob Liu <bob.liu@oracle.com> wrote:
> >
> >On 11/07/2013 04:37 AM, Boris Ostrovsky wrote:
> >> Currently balloon's initial value is set to max_pfn which includes
> >> non-RAM ranges such as MMIO hole. As result, initial memory target
> >> (specified by guest's configuration file) will appear smaller than
> >> what balloon driver perceives to be the current number of available
> >> pages. Thus it will balloon down "extra" pages, decreasing amount of
> >> available memory for no good reason.
> >>
> >
> >This fix the strange behavior I mentioned yesterday, every time after
> >guest started balloon driver will be triggered unreasonably.
> >
> >> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >> ---
> >>  drivers/xen/balloon.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> >> index b232908..1b62304 100644
> >> --- a/drivers/xen/balloon.c
> >> +++ b/drivers/xen/balloon.c
> >> @@ -641,7 +641,7 @@ static int __init balloon_init(void)
> >>
> >>  	balloon_stats.current_pages = xen_pv_domain()
> >>  		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
> >> -		: max_pfn;
> >> +		: get_num_physpages();
> >
> >By the way, should the other places using max_pfn also be changed with
> >get_num_physpages()?
>
> No. In PV that calculation is correct as it gets the amount of RAM pages - which is a exactly what you need.

What about PCI passthrough case?

Daniel
