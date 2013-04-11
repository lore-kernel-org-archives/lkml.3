Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854Ab3DKOji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:39:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437Ab3DKOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:39:37 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hhH8zwMFE54A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bUzm9BIBfnIA:10 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=zyXyCxBFDMDEMFf9-fwA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365691175.9609.33.camel@gandalf.local.home>
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 11 Apr 2013 10:39:35 -0400
In-Reply-To: <1365681898-19897-5-git-send-email-namhyung@kernel.org>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 21:04 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's for saving the page size of traced system.

Can you add a bit more detail in the change log about why this patch is
necessary.

Thanks,

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 39f0c1dca915..c37b2026d04a 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -400,6 +400,7 @@ struct pevent {
>  
>  	int cpus;
>  	int long_size;
> +	int page_size;
>  
>  	struct cmdline *cmdlines;
>  	struct cmdline_list *cmdlist;
> @@ -621,6 +622,16 @@ static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
>  	pevent->long_size = long_size;
>  }
>  
> +static inline int pevent_get_page_size(struct pevent *pevent)
> +{
> +	return pevent->page_size;
> +}
> +
> +static inline void pevent_set_page_size(struct pevent *pevent, int _page_size)
> +{
> +	pevent->page_size = _page_size;
> +}
> +
>  static inline int pevent_is_file_bigendian(struct pevent *pevent)
>  {
>  	return pevent->file_bigendian;


