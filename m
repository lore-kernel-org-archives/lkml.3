Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3DCIVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:21:55 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57385 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab3DCIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <1364976415.4353.9.camel@kjgkr>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-5-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd_+6A4nXNKbguqwgSFSJxBDM+5ZmZ+KErX0hpfwd-ieyA@mail.gmail.com>
	<1364976415.4353.9.camel@kjgkr>
Date: Wed, 3 Apr 2013 17:21:52 +0900
Message-ID: <CAKYAXd-7J3h4n8hDPLfkSLv+Yht+9kWn9QJCbrv20-D0cx3J-w@mail.gmail.com>
Subject: Re: [PATCH 5/9 v2] f2fs: change GC bitmaps to apply the section granularity
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
> Agreed, and resolved all the issues like below.
> Thanks,
>
> change log from v1:
>  o change local variable position
>  o change function shape
>  o add NULL_SECNO
>
> From f1802031a467751df6475bd3f56300137fd2ac34 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Sun, 31 Mar 2013 13:26:03 +0900
> Subject: [PATCH] f2fs: change GC bitmaps to apply the section
> granularity
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> This patch removes a bitmap for victim segments selected by foreground
> GC, and
> modifies the other bitmap for victim segments selected by background GC.
>
> 1) foreground GC bitmap
>  : We don't need to manage this, since we just only one previous victim
> section
>    number instead of the whole victim history.
>    The f2fs uses the victim section number in order not to allocate
> currently
>    GC'ed section to current active logs.
>
> 2) background GC bitmap
>  : This bitmap is used to avoid selecting victims repeatedly by
> background GCs.
>    In addition, the victims are able to be selected by foreground GCs,
> since
>    there is no need to read victim blocks during foreground GCs.
>
>    By the fact that the foreground GC reclaims segments in a section
> unit, it'd
>    be better to manage this bitmap based on the section granularity.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good to me!
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
> ---
