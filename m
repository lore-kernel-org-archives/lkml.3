Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaI3GCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:02:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15475 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaI3GCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:02:19 -0400
X-AuditID: cbfee61a-f79c06d000004e71-ba-542a4769a75a
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
 <1411447990-37919-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1411447990-37919-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 2/3] f2fs: introduce FITRIM in f2fs_ioctl
Date: Tue, 30 Sep 2014 14:01:58 +0800
Message-id: <006001cfdc74$178dcdc0$46a96940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJfDGgbbMp3eCh6ndgph+iyAEGBoQIW3l8Ymui2IWA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQd1Md60Qgzdf9CyerJ/FbHFpkbvF
	5V1z2ByYPTat6mTz2L3gM5PH501yAcxRXDYpqTmZZalF+nYJXBlHTu1gK/jGXjF583u2BsbN
	bF2MnBwSAiYSs5qnMkLYYhIX7q0HinNxCAlMZ5ToXtfGBOH8YJTYtO4bWBWbgIrE8o7/TCC2
	iICaRO++KUA2BwezgIfErmOlIGEhgWqJts8dLCA2p4CzxPWfZ8DKhYFKri67BmazCKhK3P50
	mhXE5hWwlFi+4hgzhC0o8WPyPbBeZgEtifU7jzNB2PISm9e8ZYY4VEFix9nXjBAnWEncOzKJ
	EaJGXGLjkVssExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnC4P5PawbiyweIQowAHoxIPL4e8VogQa2JZcWXuIUYJDmYlEV41c6AQb0piZVVqUX58UWlO
	avEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxmXWd9Y6/zCbKrLP6bzKAfeCZ6db
	IiYscEyUeJ5UbmrPFe5Ttz9k2pT7L8POTBRkOOyyOvzu5VqvW9t+Mm9df1D2OsMRq565ifFb
	YnXeSx16w/UhNqM+JG+ZEv8tRtvputKGxtnuanVrDrrmXNebUnfgXPj3g+fYJQvX/zb6fnrN
	/Kuzj27MM1NiKc5INNRiLipOBACTV36WcwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, September 23, 2014 12:53 PM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 2/3] f2fs: introduce FITRIM in f2fs_ioctl
> 
> This patch introduces FITRIM in f2fs_ioctl.
> In this case, f2fs will issue small discards and prefree discards as many as
> possible for the given area.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Looks good!

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> +
>  	/* zero block will be discarded through the prefree list */
>  	if (!se->valid_blocks || se->valid_blocks == max_blocks)
>  		return;
> 
> +	dmap = kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);

We can afford 64 bytes allocation in stack, how about altering dmap to a local
array to reduce memory pressure at that moment and avoid delay of allocation?

> +	if (!dmap)
> +		return;
> +


