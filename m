Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaCQLBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:01:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaCQLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:01:33 -0400
Date: Mon, 17 Mar 2014 08:01:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20140317080122.459ff9d4@infradead.org>
In-Reply-To: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 17 Mar 2014 18:55:42 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/media/platform/exynos4-is/fimc-is.c between commit d265d9ac6c7c
> ("[media] exynos4-is: Use external s5k6a3 sensor driver") from the
> v4l-dvb tree and commit fd9fdb78a9bf ("[media] of: move graph helpers
> from drivers/media/v4l2-core to drivers/of") from the staging tree.
> I fixed it up (see below, though I suspect it is wasted?) and can carry
> the fix as necessary (no action is required).

I used to have those OF patches on my tree, but I was forced to remove,
as Grant rejected the patches. After his nack, lots of dicussions about
the DT bindings started and, until last week, there were no consensus
about that (as far as I followed the discussions).

So, reluctantly, I just dropped this series from my tree, pretending
it never existed, as reverting them could cause troubles if it 
(or some version of it) got merged via Greg, Grant and/or Russell
trees.

On my head, it become too late to merge it for 3.15, as first
people must agree on the DT bindings. Also, I already closed the
media merge window, as -rc7 seems to be the last -rc.

One possible approach for this would be to merge the patches that move
the OF graph code away from drivers/media, and the corresponding
internal ABI changes early at -rc, and applying the DT binding
patches, and the staging imx-drm driver for 3.16.

Regards,
Mauro
