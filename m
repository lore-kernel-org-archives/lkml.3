Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3EaUZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:25:49 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51756 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3EaUZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:25:45 -0400
Date: Fri, 31 May 2013 22:25:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        =?utf-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for
 reimporting
Message-ID: <20130531202539.GH15743@phenom.ffwll.local>
Mail-Followup-To: Lucas Stach <l.stach@pengutronix.de>,
	=?utf-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
 <51A879E0.3080106@samsung.com>
 <20130531152956.GX15743@phenom.ffwll.local>
 <1370017269.4135.2.camel@weser.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370017269.4135.2.camel@weser.hi.pengutronix.de>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 06:21:09PM +0200, Lucas Stach wrote:
> Am Freitag, den 31.05.2013, 17:29 +0200 schrieb Daniel Vetter:
> > On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
> > > Hello Daniel,
> > > 
> > > Thanks for your comment.
> > > 
> > > On 2013년 05월 31일 18:14, Daniel Vetter wrote:
> > > > On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> > > >> importer private data in dma-buf attachment can be used by importer to
> > > >> reimport same dma-buf.
> > > >>
> > > >> Seung-Woo Kim (2):
> > > >>   dma-buf: add importer private data to attachment
> > > >>   drm/prime: find gem object from the reimported dma-buf
> > > > 
> > > > Self-import should already work (at least with the latest refcount
> > > > fixes merged). At least the tests to check both re-import on the same
> > > > drm fd and on a different all work as expected now.
> > > 
> > > Currently, prime works well for all case including self-importing,
> > > importing, and reimporting as you describe. Just, importing dma-buf from
> > > other driver twice with different drm_fd, each import create its own gem
> > > object even two import is done for same buffer because prime_priv is in
> > > struct drm_file. This means mapping to the device is done also twice.
> > > IMHO, these duplicated creations and maps are not necessary if drm can
> > > find previous import in different prime_priv.
> > 
> > Well, that's imo a bug with the other driver. If it doesn't export
> > something really simple (e.g. contiguous memory which doesn't require any
> > mmio resources at all) it should have a cache of exported dma_buf fds so
> > that it hands out the same dma_buf every time.
> 
> I agree with the reasoning here.
> 
> Though it would be nice to have this "expected driver behavior" put down
> somewhere in the documentation. Any volunteers?

I'm not sure how much sense this makes. Imo the importer side is rather
clearly spelled out, everything else is only now shaping up. And even with
the clear interface spec we pretty much have no in-tree dma_buf user who
doesn't cut corners somewhere for one or the other reason. As long the set
of exporters is fairly limited we should be fine for now.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
