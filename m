Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab3DCEZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:25:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60175 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3DCEZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <1364958193.4353.4.camel@kjgkr>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
	<1364958193.4353.4.camel@kjgkr>
Date: Wed, 3 Apr 2013 13:25:52 +0900
Message-ID: <CAKYAXd81km0Tpep=wc+vTNm=eyCx9+f2nfg4FquL=BGwhZ=dzg@mail.gmail.com>
Subject: Re: [PATCH] To add NULL pointer check
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: P J P <ppandit@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
> Thank you for your contribution.
>
> As I consider the null pointer check, generic_writepages() originally
> does so.
> Therefore, I think f2fs_write_data_pages() is better to handle this.
> Please review the modified patch.
> Thanks,
>
> ---
> From d3c811a51c7062fb1b66bec910ed346447c02032 Mon Sep 17 00:00:00 2001
> From: P J P <ppandit@redhat.com>
> Date: Wed, 3 Apr 2013 11:38:00 +0900
> Subject: [PATCH] f2fs: add NULL pointer check
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> Commit - fa9150a84c - replaces a call to generic_writepages() in
> f2fs_write_data_pages() with write_cache_pages(), with a function
> pointer
> argument pointing to routine: __f2fs_writepage.
>
>   ->
> https://git.kernel.org/linus/fa9150a84ca333f68127097c4fa1eda4b3913a22
>
>   This patch adds a NULL pointer check in f2fs_write_data_pages() to
> avoid
>   a possible NULL pointer dereference, in case if -
> mapping->a_ops->writepage -
>   is NULL.
Yes, I  agree. Looks better!
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
>
> Signed-off-by: P J P <ppandit@redhat.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
