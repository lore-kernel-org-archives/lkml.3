Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3AONp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:45:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3AONp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:45:58 -0500
X-Authority-Analysis: v=2.0 cv=UsXhxpMB c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DbEw_xh21akA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=C8D8j3Lp6psA:10 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=hxKhD864DLpISpfytw0A:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358257555.4068.11.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Fix warning on '>=' operator
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Tue, 15 Jan 2013 08:45:55 -0500
In-Reply-To: <1358236939-17393-1-git-send-email-namhyung@kernel.org>
References: <1358236939-17393-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 17:02 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Although the '>=' (and '<=') operator is handled properly in
> libtraceevent, it emitted following spurious warnings on perf test:
> 
>  $ perf test
>  5: parse events tests                                     :
>   ...
>   Warning: unknown op '>='
>   Warning: unknown op '>='
>   Warning: unknown op '>='
>   Warning: unknown op '>='
>   Warning: unknown op '>='
>   Warning: unknown op '>='
>   ...
> 
> Add the operator to the checks.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5a824e355d04..7286f0e82c29 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -1785,6 +1785,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
>  		   strcmp(token, "/") == 0 ||
>  		   strcmp(token, "<") == 0 ||
>  		   strcmp(token, ">") == 0 ||
> +		   strcmp(token, "<=") == 0 ||
> +		   strcmp(token, ">=") == 0 ||
>  		   strcmp(token, "==") == 0 ||
>  		   strcmp(token, "!=") == 0) {
>  


