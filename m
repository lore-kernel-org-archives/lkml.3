Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaFDBwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:52:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45917 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaFDBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:52:12 -0400
Message-ID: <538E7BC8.9090005@gmail.com>
Date: Tue, 03 Jun 2014 19:52:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: jolsa@redhat.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: Re: [PATCH 06/32] perf kbuild: store in config-detected missing variables
 (libdir, ...)
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com> <1401833185-10347-7-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1401833185-10347-7-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ditto. you need a blurb here as to what is happening in the patch below.

On 6/3/14, 4:05 PM, Alexis Berlemont wrote:
> ---
>   tools/perf/Makefile.kbuild | 5 ++++-
>   tools/perf/config/Makefile | 3 +++
>   2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
> index b2d0d08..e82615f 100644
> --- a/tools/perf/Makefile.kbuild
> +++ b/tools/perf/Makefile.kbuild
> @@ -212,8 +212,11 @@ export prefix_SQ
>   export PARSER_DEBUG_BISON
>   export PARSER_DEBUG_FLEX
>   export ETC_PERFCONFIG_SQ
> +export libdir_SQ
>   export PYTHON_EMBED_CCOPTS
>   export PERL_EMBED_CCOPTS
> +export GTK_CFLAGS
> +
>   endif
>
>   # let sources know it's kbuild
> @@ -262,7 +265,7 @@ $(obj-perf)/built-in.o: $(obj-perf)/common-cmds.h FORCE
>   LIBS = -Wl,--whole-archive $^ -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
>
>   tools/perf/perf: $(obj-perf)/built-in.o $(LIBS_A)
> -	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(LIBS)
> +	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(LIBS) $(GTK_LIBS)

unrelated changes should be in separate patches.

David

