Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3FHBMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:12:21 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53678 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FHBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:12:20 -0400
Date: Fri, 7 Jun 2013 18:12:22 -0700
From: Olof Johansson <olof@lixom.net>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Simon Glass'" <sjg@chromium.org>, linux-samsung-soc@vger.kernel.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: exynos: add debug_ll_io_init() call in
 exynos_init_io()
Message-ID: <20130608011222.GC27436@quad.lixom.net>
References: <1370397539-21653-1-git-send-email-dianders@chromium.org>
 <1370465793-7997-1-git-send-email-dianders@chromium.org>
 <CAOesGMhQX9ip=nb9AQa5fcDFRNpZZSxUO0N0GTX051dakWZD9Q@mail.gmail.com>
 <09ca01ce6244$e2f0e7a0$a8d2b6e0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09ca01ce6244$e2f0e7a0$a8d2b6e0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 08:32:04AM +0900, Kukjin Kim wrote:
> Olof Johansson wrote:
> > 
> > On Wed, Jun 5, 2013 at 1:56 PM, Doug Anderson <dianders@chromium.org>
> > wrote:
> > > If the early MMU mapping of the UART happens to get booted out of the
> > > TLB between the start of paging_init() and when we finally re-add the
> > > UART at the very end of s3c_init_cpu(), we'll get a hang at bootup if
> > > we've got early_printk enabled.  Avoid this hang by calling
> > > debug_ll_io_init() early.
> > >
> > > Without this patch, you can reliably reproduce a hang when early
> > > printk is enabled by adding flush_tlb_all() at the start of
> > > exynos_init_io().  After this patch the hang goes away.
> > >
> > > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > 
> > Acked-by: Olof Johansson <olof@lixom.net>
> > 
> > 
> > Kukjin, this seems appropriate for 3.10. Do you have other fixes
> > queued or should I apply this directly?
> > 
> If I remember correctly, nothing in my tree for 3.10.
> 
> So please go ahead with my ack if you want,
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 

Applied for 3.10 (together with the uncompress.h fix from Tushar)


-Olof
