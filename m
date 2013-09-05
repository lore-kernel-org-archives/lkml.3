Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3IEO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:29:18 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62778 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3IEO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:29:16 -0400
Message-ID: <52289536.3070504@gmail.com>
Date: Thu, 05 Sep 2013 08:29:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: Clarify error when running "perf lock record"
References: <1378369936-26473-1-git-send-email-rodrigo@sdfg.com.ar>
In-Reply-To: <1378369936-26473-1-git-send-email-rodrigo@sdfg.com.ar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/13 2:32 AM, Rodrigo Campos wrote:
> If you have the config options enabled in your kernel, you still need to be root
> to run perf lock. And is kind of misleading when you have that options enabled
> and the error says that they might not be.
>
> So, this patch just adds to the error that it should be run as root. Although we
> can probably check if it's running as root or not, adding it to the error
> message is really simple and should be enough.
>
> Signed-off-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
> ---
> Please keep me in Cc: since I'm not subscribed
> ---
>   tools/perf/builtin-lock.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 76543a4..f07b318 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -886,8 +886,8 @@ static int __cmd_record(int argc, const char **argv)
>   	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
>   		if (!is_valid_tracepoint(lock_tracepoints[i].name)) {
>   				pr_err("tracepoint %s is not enabled. "
> -				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?\n",
> -				       lock_tracepoints[i].name);
> +				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled "
> +				       "and running as root?\n", lock_tracepoints[i].name);
>   				return 1;
>   		}
>   	}
>

you can run perf-lock as non-root with certain settings. It would be 
better to discriminate debugfs access errors (insufficient privilege). 
That means improving is_valid_tracepoint and handling the errors in 
perf-lock.

David
