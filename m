Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161055Ab3CVQwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:52:17 -0400
Received: from void.printf.net ([89.145.121.20]:38460 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160998Ab3CVQwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:52:15 -0400
From: Chris Ball <cjb@laptop.org>
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Jaehoon Chung" <jh80.chung@samsung.com>
Subject: Re: [PATCH 3/3] dw_mmc: Handle unaligned data submission correctly
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
	<1363085593-22214-3-git-send-email-markos.chandras@imgtec.com>
Date: Fri, 22 Mar 2013 12:52:12 -0400
In-Reply-To: <1363085593-22214-3-git-send-email-markos.chandras@imgtec.com>
	(Markos Chandras's message of "Tue, 12 Mar 2013 10:53:13 +0000")
Message-ID: <87vc8jml6r.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 12 2013, Markos Chandras wrote:
> Commit f9c2a0dc42a6938ff2a80e55ca2bbd1d5581c72e
> "mmc: dw_mmc: Fix PIO mode with support of highmem" introduced
> a regression since v3.2 making the mmc_test hang on test #13
> with a "Data starvation by host timeout" interrupt.
>
> This is because, sg_mapping_iter is used to iterate through the
> data which spans on multiple pages. The problem is detected on
> unaligned data submission where the code previously checked for
> !(sg_next(host->sg)) which is true because we only have a single
> scatter/gather list which then expands to multiple pages.
> Therefore, the driver incorrectly assumed that this was the last
> list item and submitted unaligned data to the mmc device. This
> overflowed the FIFO on the device before all the data were written
> to it. The code was fixed to only submit unaligned data when we are
> handling the last sg_miter item by checking whether we reached
> the desired data length or not.
>
> The patch was tested against mmc_test and all the tests passed.
>
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
