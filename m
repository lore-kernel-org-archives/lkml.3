Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaBKSbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:31:07 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57605 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:31:04 -0500
Message-ID: <52FA6C65.3080901@gmail.com>
Date: Tue, 11 Feb 2014 11:31:01 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
References: <20140211121411.GA4368@infradead.org> <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/14, 9:49 AM, Peter Hurley wrote:
> From: Peter Hurley <peter@hurleysoftware.com>
> Date: Tue, 11 Feb 2014 10:10:07 -0500
> Subject: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
>
> Commit eafbe67f84761d787802e5113d895a316b6292fe,
>    n_tty: Refactor input_available_p() by call site
> broke poll() when TIME_CHAR(tty) and MIN_CHAR(tty) are both 0.
>
> When TIME_CHAR and MIN_CHAR are both 0, input is available if the
> read_cnt is 1 (not 0).
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/n_tty.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index cb8017a..2747a3b 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1896,7 +1896,7 @@ err:
>   static inline int input_available_p(struct tty_struct *tty, int poll)
>   {
>   	struct n_tty_data *ldata = tty->disc_data;
> -	int amt = poll && !TIME_CHAR(tty) ? MIN_CHAR(tty) : 1;
> +	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
>
>   	if (ldata->icanon && !L_EXTPROC(tty)) {
>   		if (ldata->canon_head != ldata->read_tail)
>

Worked for me.

Tested-by: David Ahern <dsahern@gmail.com>
