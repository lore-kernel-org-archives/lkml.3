Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3FQH7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:59:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28447 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3FQH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:59:49 -0400
Date: Mon, 17 Jun 2013 10:59:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
Message-ID: <20130617075925.GB5008@mwanda>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
 <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
 <20130613182447.GB32574@mithrandir>
 <20130613131415.aa4f675f151c586f5f6b2123@linux-foundation.org>
 <20130613213920.GA32732@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613213920.GA32732@mithrandir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:39:25PM +0200, Thierry Reding wrote:
> On Thu, Jun 13, 2013 at 01:14:15PM -0700, Andrew Morton wrote:
> > On Thu, 13 Jun 2013 20:24:48 +0200 Thierry Reding <thierry.reding@gmail.com> wrote:
> > 
> > > On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
> > > > On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > > > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> > > > > introduced devm_ioremap_resource() and encourage to check its return value with
> > > > > IS_ERR(). This however leads to the following sparse warnings, as
> > > > > devm_ioremap_resource() returns a void __iomem pointer:
> > > > >
> > > > > drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type in argument 1 (different address spaces)
> > > > > drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *ptr
> > > > > drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [noderef] [usertype] <asn:2>*raminit_ctrlreg
> > > > 
> > > > CC ing Thierry who has solved this issue some time back.
> > > 
> > > I had sent two patches, one against sparse, the other against the
> > > kernel, but none were picked up yet.
> > 
> > I didn't know that.
> > 
> > On May 8 I queued
> > http://ozlabs.org/~akpm/mmots/broken-out/errh-is_err-can-accept-__user-pointers.patch.
> > Dan says that sparse v0.4.5-rc1 or later is also required.
> 
> So maybe latest sparse does have the patch. I didn't find it looking at
> the logs. But looking again it seems like an equivalent patch made it in
> recently. Also the above patch looks very much like what I posted back
> at the time. Shame that work was duplicated, maybe I should have pushed
> harder when I didn't get a response.
> 
> Thierry

Sorry about that.  I didn't mean to steal anyone's patch.

regards,
dan carpenter
