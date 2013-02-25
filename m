Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3BYJQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:16:40 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:51404 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab3BYJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:16:38 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1361288879-21436-1-git-send-email-gorcunov@openvz.org>
References: <1361288879-21436-1-git-send-email-gorcunov@openvz.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 25 Feb 2013 10:16:17 +0100
Message-ID: <CAKgNAkia6T0P1e8v20kw1fJhuV9Cbf+p2wZtppgJ2O8MvAJ1Eg@mail.gmail.com>
Subject: Re: [PATCH] man2/prctl.2: Add PR_GET_TID_ADDRESS description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

On Tue, Feb 19, 2013 at 4:47 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  man2/prctl.2 | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 012af4d..4906c70 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -761,6 +761,18 @@ option.
>  .\" symbolic-link transitions over all process running in a system.
>  .\" ========== END FIXME
>  .RE
> +.TP
> +.BR PR_GET_TID_ADDRESS " (since Linux 3.5)"
> +Return
> +.I clear_child_tid
> +in the location pointed by
> +.IR "(int\ **) arg2" .
> +See
> +.BR set_tid_address (2)
> +for more details.
> +This feature is available only if the kernel is built with the
> +.BR CONFIG_CHECKPOINT_RESTORE
> +option enabled.
>  .\"
>  .SH "RETURN VALUE"
>  On success,


As it happened, I added documentation for this flag a few weeks ago,
but your patc includes some details that I didn't document, so I've
applied those pieces to yield:

       PR_GET_TID_ADDRESS (since Linux 3.5)
              Retrieve   the   clear_child_tid    address    set    by
              set_tid_address(2) and the clone(2) CLONE_CHILD_CLEARTID
              flag, in the location pointed to by (int **) arg2.  This
              feature  is  available  only if the kernel is built with
              the CONFIG_CHECKPOINT_RESTORE option enabled.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
