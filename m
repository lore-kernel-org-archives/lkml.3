Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaBKUux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:50:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbaBKUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:50:50 -0500
Date: Tue, 11 Feb 2014 18:50:35 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
Message-ID: <20140211205035.GB4368@infradead.org>
References: <20140211121411.GA4368@infradead.org>
 <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit eafbe67f84761d787802e5113d895a316b6292fe,
>   n_tty: Refactor input_available_p() by call site
> broke poll() when TIME_CHAR(tty) and MIN_CHAR(tty) are both 0.
> 
> When TIME_CHAR and MIN_CHAR are both 0, input is available if the
> read_cnt is 1 (not 0).
> 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Thanks,

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo

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
> -- 
> 1.8.1.2
