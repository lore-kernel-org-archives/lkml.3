Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbbA2L0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:26:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbbA2LZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:25:48 -0500
X-AuditID: cbfee61a-f79c06d000004e71-fb-54ca18b96b96
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 1/5] f2fs: fix not to drop mount options when retrying
 fill_super
Date: Thu, 29 Jan 2015 19:24:59 +0800
Message-id: <002a01d03bb6$530c8340$f92589c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDs63B3JtDSVeEmIqjDxgyUQN23JtwArDw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd2dEqdCDG6eNbF4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+PA+v2sBe9ZK/pb
	2tgbGN+xdDFyckgImEjMm7uJCcIWk7hwbz1bFyMXh5DAdEaJN0uWQTk/GCX23F7ICFLFJqAi
	sbzjPxNIQkSgl1Hix5l+ZpCEkICjxOr5Z1hBbE4BJ4kLy5aCrRAWCJf4+aWRHcRmEVCVOL/z
	INg6XgFLib6nn9ggbEGJH5PvgdUzC2hJrN95nAnClpfYvOYtM8R5ChI7zr4GO0JEwEji+boZ
	UDXiEhuP3GKZwCg4C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcx
	goP8mdQOxpUNFocYBTgYlXh4OepPhgixJpYVV+YeYpTgYFYS4RUTOBUixJuSWFmVWpQfX1Sa
	k1p8iFGag0VJnFfJvi1ESCA9sSQ1OzW1ILUIJsvEwSnVwGgxda3ZkbL7a5/V2G9raQ8I1Vg3
	ZypXp9ivnmNh6fsdX4l+nC9zT3fZsQOvtisGf/fNObBdbpf+hmk3SxbdzD14Km/atC0HLzLa
	KBedUrPZJ612N03yidVshmXX7657kDGl7eYL8bAbZi9drvX/7m9SSjJpiLm4almQ7/JjuRlV
	cnN4Th5eauSgxFKckWioxVxUnAgAaph2n24CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On
> Behalf Of Jaegeuk Kim
> Sent: Wednesday, January 28, 2015 7:32 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [PATCH 1/5] f2fs: fix not to drop mount options when retrying fill_super
> 
> If wrong mount option was requested, f2fs tries to fill_super again.
> But, during the next trial, f2fs has no valid mount options, since
> parse_options deleted all the separators in the original string.

Nice catch!

But couldn't we encounter memory leak for options if we did not fail to fill super.

Thanks,

