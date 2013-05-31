Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3EaQXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:23:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52500 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3EaQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:23:10 -0400
Message-ID: <1370017269.4135.2.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for
 reimporting
From: Lucas Stach <l.stach@pengutronix.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: =?UTF-8?Q?=EA=B9=80=EC=8A=B9=EC=9A=B0?= <sw0312.kim@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 31 May 2013 18:21:09 +0200
In-Reply-To: <20130531152956.GX15743@phenom.ffwll.local>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
	 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
	 <51A879E0.3080106@samsung.com> <20130531152956.GX15743@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 31.05.2013, 17:29 +0200 schrieb Daniel Vetter:
> On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
> > Hello Daniel,
> > 
> > Thanks for your comment.
> > 
> > On 2013년 05월 31일 18:14, Daniel Vetter wrote:
> > > On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> > >> importer private data in dma-buf attachment can be used by importer to
> > >> reimport same dma-buf.
> > >>
> > >> Seung-Woo Kim (2):
> > >>   dma-buf: add importer private data to attachment
> > >>   drm/prime: find gem object from the reimported dma-buf
> > > 
> > > Self-import should already work (at least with the latest refcount
> > > fixes merged). At least the tests to check both re-import on the same
> > > drm fd and on a different all work as expected now.
> > 
> > Currently, prime works well for all case including self-importing,
> > importing, and reimporting as you describe. Just, importing dma-buf from
> > other driver twice with different drm_fd, each import create its own gem
> > object even two import is done for same buffer because prime_priv is in
> > struct drm_file. This means mapping to the device is done also twice.
> > IMHO, these duplicated creations and maps are not necessary if drm can
> > find previous import in different prime_priv.
> 
> Well, that's imo a bug with the other driver. If it doesn't export
> something really simple (e.g. contiguous memory which doesn't require any
> mmio resources at all) it should have a cache of exported dma_buf fds so
> that it hands out the same dma_buf every time.

I agree with the reasoning here.

Though it would be nice to have this "expected driver behavior" put down
somewhere in the documentation. Any volunteers?

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

