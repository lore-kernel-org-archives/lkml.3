Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3CEIul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:50:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3CEIuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:50:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC/PATCH 0/5] Contiguous Memory Allocator and get_user_pages()
Date: Tue, 5 Mar 2013 08:50:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303050850.26615.arnd@arndb.de>
X-Provags-ID: V02:K0:VmkjzvW4qoIH97ufrJwBlnmj54luPp46e1lB+psV2TB
 vTvddy1X1E++f2BPRGGQkGetC//U70H1Annh8ode+dKnLDXpuC
 V7V7pmM9ZesdJhIkGHbjGdd0p6UwJB3I5CxMY2zeHxCJzJT723
 x0XBaHq7PnQrb0oAcBu9TTEEKXIZ5myQW1iBf8RsrA6ZBJnlNk
 RKCqRkVfjW3BPT+E2cbm6l7MacL8ImTKND2Db8NM5wA5VkfngW
 4g664HzwHsTGkEFX2EYF5ySmaFuGrj7gCgw8Q5zwOxdRxPw56v
 zl2fa6HL9s2tWC1dChfeB/U90Of1C3j4H247hO1eeUFy61TSj9
 ijtEhnwA/oF1kpKeaRSs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Marek Szyprowski wrote:
> To solving this issue requires preventing locking of the pages, which
> are placed in CMA regions, for a long time. Our idea is to migrate
> anonymous page content before locking the page in get_user_pages(). This
> cannot be done automatically, as get_user_pages() interface is used very
> often for various operations, which usually last for a short period of
> time (like for example exec syscall). We have added a new flag
> indicating that the given get_user_space() call will grab pages for a
> long time, thus it is suitable to use the migration workaround in such
> cases.

Can you explain the tradeoff here? I would have expected that the default
should be to migrate pages out, and annotate the instances that we know
are performance critical and short-lived. That would at least appear
more reliable to me.

	Arnd
