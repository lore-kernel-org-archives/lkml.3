Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3AWOmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:42:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3AWOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:42:18 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=NpjRPGXs834A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=KYlOPR1D8z8A:10 a=YgwN3AOMAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=fB5lnGKdFrWL4hk70WAA:9 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358952137.21576.117.camel@gandalf.local.home>
Subject: Re: [PATCH 11/15] tools/lib/traceevent/event-parse.c: adjust
 duplicate test
From: Steven Rostedt <rostedt@goodmis.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 23 Jan 2013 09:42:17 -0500
In-Reply-To: <1358773378-4700-12-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1358773378-4700-12-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 14:02 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive tests to the same location.  Field was already tested.
> Alloc_arg can fail, so test that value instead.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@
> 
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> ... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
>     when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  tools/lib/traceevent/event-parse.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5a824e3..7538a1f 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2481,7 +2481,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
>  
>  	free_token(token);
>  	arg = alloc_arg();
> -	if (!field) {
> +	if (!arg) {
>  		do_warning("%s: not enough memory!", __func__);
>  		*tok = NULL;
>  		return EVENT_ERROR;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


