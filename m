Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaBKSc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:32:58 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36051 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaBKSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:32:57 -0500
Message-ID: <1392143574.6615.87.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 11 Feb 2014 10:32:54 -0800
In-Reply-To: <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
References: <20140211121411.GA4368@infradead.org>
	 <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 11:49 -0500, Peter Hurley wrote:

> From: Peter Hurley <peter@hurleysoftware.com>
> Date: Tue, 11 Feb 2014 10:10:07 -0500
> Subject: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
> 
> Commit eafbe67f84761d787802e5113d895a316b6292fe,
>   n_tty: Refactor input_available_p() by call site
> broke poll() when TIME_CHAR(tty) and MIN_CHAR(tty) are both 0.
> 
> When TIME_CHAR and MIN_CHAR are both 0, input is available if the
> read_cnt is 1 (not 0).
> 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index cb8017a..2747a3b 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1896,7 +1896,7 @@ err:
>  static inline int input_available_p(struct tty_struct *tty, int poll)
>  {
>  	struct n_tty_data *ldata = tty->disc_data;
> -	int amt = poll && !TIME_CHAR(tty) ? MIN_CHAR(tty) : 1;
> +	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
>  
>  	if (ldata->icanon && !L_EXTPROC(tty)) {
>  		if (ldata->canon_head != ldata->read_tail)

Reported-by: Eric Dumazet <edumazet@google.com>
Tested-by: Eric Dumazet <edumazet@google.com>

Thanks guys


