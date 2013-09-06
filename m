Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3IFOFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:05:22 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46527 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3IFOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:05:20 -0400
Message-ID: <5229E11D.9080407@gmail.com>
Date: Fri, 06 Sep 2013 08:05:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Free strlist in strlist__delete()
References: <1378445726-10877-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1378445726-10877-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/13 11:35 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> It seems strlist never deleted after allocated.  AFAICS every strlist
> is allocated dynamically, just free it in the _delete() function.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/util/strlist.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
> index eabdce0a2daa..11593d899eb2 100644
> --- a/tools/perf/util/strlist.c
> +++ b/tools/perf/util/strlist.c
> @@ -155,8 +155,10 @@ out_error:
>
>   void strlist__delete(struct strlist *slist)
>   {
> -	if (slist != NULL)
> +	if (slist != NULL) {
>   		rblist__delete(&slist->rblist);
> +		free(slist);
> +	}
>   }
>
>   struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx)
>

Yes, strlist__delete is the counterpart to strlist__new; the new 
function allocates the memory, so the delete should free it.

Acked-by: David Ahern <dsahern@gmail.com>
