Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaCMDse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:48:34 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38098 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaCMDsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140312133403.GB29079@shuo-gentoo>
References: <20140312132441.GA29079@shuo-gentoo>
	<20140312133403.GB29079@shuo-gentoo>
Date: Wed, 12 Mar 2014 20:48:32 -0700
X-Google-Sender-Auth: pV9Yei-LABSo_Y5Ro9JgZ-Y0S_E
Message-ID: <CAGXu5jJuUf4dwFqAZJgqRduw_oEN=H-FUh8vEDuThnhp9MPxKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pstore: fix memory leak when decompress using big_oops_buf
From: Kees Cook <keescook@chromium.org>
To: Liu Shuo <shuox.liu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 6:34 AM, Liu Shuo <shuox.liu@gmail.com> wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> After sucessful decompressing, the buffer which pointed by 'buf' will be
> lost as 'buf' is overwrite by 'big_oops_buf' and will never be freed.
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>

Thanks again!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> fs/pstore/platform.c | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 78c3c20..46d269e 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -497,6 +497,7 @@ void pstore_get_records(int quiet)
>                                                         big_oops_buf_sz);
>
>                         if (unzipped_len > 0) {
> +                               kfree(buf);
>                                 buf = big_oops_buf;
>                                 size = unzipped_len;
>                                 compressed = false;
> --
> 1.8.3.2
>



-- 
Kees Cook
Chrome OS Security
