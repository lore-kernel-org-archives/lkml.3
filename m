Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaFDBxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:53:41 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62199 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaFDBxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:53:40 -0400
Message-ID: <538E7C20.2060407@gmail.com>
Date: Tue, 03 Jun 2014 19:53:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: jolsa@redhat.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: Re: [PATCH 07/32] perf kbuild: remove useless #ifdef directives
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com> <1401833185-10347-8-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1401833185-10347-8-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

missing commit message as to why the ifdef directives useless.

if I build perf after applying this patch and I don't have devel code 
for tui and gui will it still build?

David

On 6/3/14, 4:06 PM, Alexis Berlemont wrote:
> ---
>   tools/perf/ui/setup.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
> index 66ecd08..cb69740 100644
> --- a/tools/perf/ui/setup.c
> +++ b/tools/perf/ui/setup.c
> @@ -71,20 +71,16 @@ void setup_browser(bool fallback_to_pager)
>
>   	switch (use_browser) {
>   	case 2:
> -#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
>   		if (setup_gtk_browser() == 0)
>   			break;
>   		printf("GTK browser requested but could not find %s\n",
>   		       PERF_GTK_DSO);
>   		sleep(1);
> -#endif
>   		/* fall through */
> -#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
>   	case 1:
>   		use_browser = 1;
>   		if (ui__init() == 0)
>   			break;
> -#endif
>   		/* fall through */
>   	default:
>   		use_browser = 0;
> @@ -100,16 +96,12 @@ void exit_browser(bool wait_for_ok __maybe_unused)
>   {
>   	switch (use_browser) {
>   	case 2:
> -#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
>   		exit_gtk_browser(wait_for_ok);
>   		break;
> -#endif
>
> -#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
>   	case 1:
>   		ui__exit(wait_for_ok);
>   		break;
> -#endif
>
>   	default:
>   		break;
>

