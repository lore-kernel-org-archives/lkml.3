Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaG3WUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:20:43 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47018 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaG3WUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:20:42 -0400
Message-ID: <53D96FBB.4010907@gmail.com>
Date: Wed, 30 Jul 2014 16:20:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
CC: Minchan Kim <minchan@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org> <20140729050246.GC22707@bbox> <20140729123305.GO7831@kernel.org> <87ppgnhge3.fsf@sejong.aot.lge.com> <20140730151932.GS7831@kernel.org> <20140730205521.GU7831@kernel.org>
In-Reply-To: <20140730205521.GU7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/14, 2:55 PM, Arnaldo Carvalho de Melo wrote:
> @@ -143,6 +144,14 @@ struct symbol_conf {
>   };
>
>   extern struct symbol_conf symbol_conf;
> +
> +static inline int __symbol__join_symfs(char *bf, size_t size, const char *path)
> +{
> +	return path__join(bf, size, symbol_conf.symfs, path);
> +}
> +
> +#define symbol__join_symfs(bf, path) __symbol__join_symfs(bf, sizeof(bf), path)
> +
>   extern int vmlinux_path__nr_entries;
>   extern char **vmlinux_path;
>

I am not comfortable with the sizeof(bf) in the macro there. It is to a 
large degree hiding an important detail and sets up odd failures in the 
future. ie., It works fine for 'char bf[N];' but not for 'char *bf = 
"some string";'.

David
