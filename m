Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaIIRTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:19:11 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65485 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaIIRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140909131036.7265121f.m.chehab@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
	<6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
	<b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
	<540F15B2.3000902@samsung.com>
	<20140909120936.527bd852.m.chehab@samsung.com>
	<540F1D11.9030400@samsung.com>
	<20140909131036.7265121f.m.chehab@samsung.com>
Date: Tue, 9 Sep 2014 14:19:07 -0300
Message-ID: <CAOMZO5ASN_Kcp4q-stmsoXBFcmtJLyyeEEpwy=U40qqghT7vXA@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 1:10 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!
>
> That happens because asm-generic doesn't like any ndelay time
> bigger than 20us.
>
> Currently, usleep_range() couldn't simply be used, since
> exynos4_jpeg_sw_reset() is called with a spinlock held.
>
> So, let's use ndelay() instead.

You meant 'udelay() instead'.
