Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaHLO6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:58:53 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:42679 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaHLO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <1407628009-24701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1407628009-24701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 12 Aug 2014 07:58:50 -0700
X-Google-Sender-Auth: oHpFgyh1UV6FZGrfcbY0Wnq7wR4
Message-ID: <CAGXu5jJxHsr2YKL8vN2W24F_KEcVOAa480+VhCLB+re+hswtfg@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: workitem.c: Cleaning up
 missing null-terminate after strncpy call
From: Kees Cook <keescook@chromium.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Masanari Iida <standby24x7@gmail.com>,
        Mike Sampson <mike@sambodata.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 4:46 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Added a guaranteed null-terminate after call to strncpy.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/lustre/lustre/libcfs/workitem.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
> index 0a03bf7..60326f2 100644
> --- a/drivers/staging/lustre/lustre/libcfs/workitem.c
> +++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
> @@ -365,6 +365,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
>                 return -ENOMEM;
>
>         strncpy(sched->ws_name, name, CFS_WS_NAME_LEN);
> +       sched->ws_name[CFS_WS_NAME_LEN - 1] = '\0';
>         sched->ws_cptab = cptab;
>         sched->ws_cpt = cpt;

This seems like a place for strlcpy instead?

-Kees

-- 
Kees Cook
Chrome OS Security
