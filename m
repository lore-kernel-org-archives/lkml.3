Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3FMUOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3FMUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:14:16 -0400
Date: Thu, 13 Jun 2013 13:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
Message-Id: <20130613131415.aa4f675f151c586f5f6b2123@linux-foundation.org>
In-Reply-To: <20130613182447.GB32574@mithrandir>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
	<CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
	<20130613182447.GB32574@mithrandir>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 20:24:48 +0200 Thierry Reding <thierry.reding@gmail.com> wrote:

> On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
> > On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> > > introduced devm_ioremap_resource() and encourage to check its return value with
> > > IS_ERR(). This however leads to the following sparse warnings, as
> > > devm_ioremap_resource() returns a void __iomem pointer:
> > >
> > > drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type in argument 1 (different address spaces)
> > > drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *ptr
> > > drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [noderef] [usertype] <asn:2>*raminit_ctrlreg
> > 
> > CC ing Thierry who has solved this issue some time back.
> 
> I had sent two patches, one against sparse, the other against the
> kernel, but none were picked up yet.

I didn't know that.

On May 8 I queued
http://ozlabs.org/~akpm/mmots/broken-out/errh-is_err-can-accept-__user-pointers.patch.
Dan says that sparse v0.4.5-rc1 or later is also required.
