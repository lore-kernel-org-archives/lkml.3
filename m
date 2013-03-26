Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab3CZAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:48:20 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:55493 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799Ab3CZAsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
Date: Tue, 26 Mar 2013 09:48:18 +0900
Message-ID: <CAKYAXd_z6oWgrRj3dQ=_OieZ1twnoQqhGLaQah5rp_j9ge858A@mail.gmail.com>
Subject: Re: [PATCH 2/4] f2fs: do not skip writing file meta during fsync
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> This patch removes data_version check flow during the fsync call.
> The original purpose for the use of data_version was to avoid writng inode
> pages redundantly by the fsync calls repeatedly.
Hi Jaegeuk.
> However, when user can modify file meta and then call fsync, we should not
> skip fsync procedure.
I have a question.
Which case does user can directly modify meta ? Recovery tool ?

Thanks.

> So, let's remove this condition check and hope that user triggers in right
> manner.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
