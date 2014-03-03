Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaCCTqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:46:54 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:50447 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaCCTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:46:53 -0500
MIME-Version: 1.0
In-Reply-To: <1393569501-14952-1-git-send-email-shuox.liu@intel.com>
References: <1393569501-14952-1-git-send-email-shuox.liu@intel.com>
Date: Mon, 3 Mar 2014 11:46:52 -0800
X-Google-Sender-Auth: d3pBDVT7xiUrqyJ7pRkLIxXesHA
Message-ID: <CAGXu5jKs9jNcVpwk-sk9pjYv_-N_Ud5VVjdBKPcxP9RjE0dtgQ@mail.gmail.com>
Subject: Re: [PATCH] pstore: skip zero size persistent ram buffer in traverse
From: Kees Cook <keescook@chromium.org>
To: shuox.liu@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:38 PM,  <shuox.liu@intel.com> wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> In ramoops_pstore_read, a valid prz pointer with zero size buffer will
> break traverse of all persistent ram buffers. The latter buffer might
> be lost.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>  fs/pstore/ram.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index a5d0cab..929ea55 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -119,12 +119,12 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
>
>         prz = przs[i];
>
> -       if (update) {
> -               /* Update old/shadowed buffer. */
> +       /* Update old/shadowed buffer. */
> +       if (update)
>                 persistent_ram_save_old(prz);
> -               if (!persistent_ram_old_size(prz))
> -                       return NULL;
> -       }
> +
> +       if (!persistent_ram_old_size(prz))
> +               return NULL;
>
>         *typep = type;
>         *id = i;

Good catch; this change makes sense to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
