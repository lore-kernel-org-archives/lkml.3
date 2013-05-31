Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3EaGpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:45:22 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41947 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3EaGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:45:11 -0400
MIME-Version: 1.0
Date: Fri, 31 May 2013 12:15:10 +0530
Message-ID: <CAK9yfHyZH3DSg2ZLbPN2bjQppWZSMR+2hQE+OU76eqSJoWAWGA@mail.gmail.com>
Subject: Regression introduced by commit "lib/bitmap.c: speed up bitmap_find_free_region"
From: Sachin Kamat <sachin.kamat@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chanho.min@lge.com,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Arun Kumar K <arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing MFC decoder on Exynos machines, I encountered some
memory allocation errors due to failure of dma_alloc_coherent().
File: drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c Line: 38.

Git bisect pointed me to the following commit as the first bad commit
(linux-next tree of 20130531):

commit 3d5272d9b289cd0930b2ea9984406d757a72f4dd
Author: Chanho Min <chanho.min@lge.com>
Date:   Thu May 23 10:37:28 2013 +1000
    lib/bitmap.c: speed up bitmap_find_free_region

Reverting this (and the commit 197e1cf7
("ib-bitmapc-speed-up-bitmap_find_free_region-fix") ) fixes this
issue.

Looks like some regression has been introduced by the above patch?

---
With warm regards,
Sachin
