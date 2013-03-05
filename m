Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3CEJTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:19:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:53601 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3CEJTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:19:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="scan'208";a="271193193"
Message-ID: <1362475141.28241.111.camel@smile>
Subject: Re: [PATCH 04/10] dmatest: move dmatest_channels and nr_channels to
 dmatest_info
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 05 Mar 2013 11:19:01 +0200
In-Reply-To: <CAKohpomECZjXcaM-n64vfq+DMc9_G2aqa5ShfJ4j+_wVaeBrRQ@mail.gmail.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpomECZjXcaM-n64vfq+DMc9_G2aqa5ShfJ4j+_wVaeBrRQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 17:12 +0800, Viresh Kumar wrote: 
> On 4 March 2013 17:09, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > We don't need to have them global and later we would like to protect access to
> > them as well.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dmatest.c | 29 ++++++++++++++++-------------
> >  1 file changed, 16 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> > index 7f9e3cc..475a21a 100644
> > --- a/drivers/dma/dmatest.c
> > +++ b/drivers/dma/dmatest.c
> > @@ -109,6 +109,7 @@ struct dmatest_chan {
> >   * @timeout:           transfer timeout in msec, -1 for infinite timeout
> >   */
> >  struct dmatest_info {
> > +       /* Test parameters */
> >         unsigned int    buf_size;
> >         char            channel[20];
> >         char            device[20];
> > @@ -118,17 +119,14 @@ struct dmatest_info {
> >         unsigned int    xor_sources;
> >         unsigned int    pq_sources;
> >         int             timeout;
> > +
> > +       /* Internal state */
> > +       struct list_head        channels;
> > +       unsigned int            nr_channels;
> >  };
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> What about merging this patch with the patch which added this structure.

As I said in cover letter I believe that few patches could be merged,
but I would like to discuss the main point first.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
