Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3IYNAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:00:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54834 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3IYNAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:00:12 -0400
Message-ID: <5242DE54.8040607@gmail.com>
Date: Wed, 25 Sep 2013 07:00:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf tool: Explicitly add libdl dependency
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com> <1379900700-5186-3-git-send-email-dsahern@gmail.com>
In-Reply-To: <1379900700-5186-3-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

I am not seeing this one in your tree. Any objections to it? It is 
required to fix static compiles. e.g.,

make LDFLAGS=-static NO_LIBPYTHON=1 NO_LIBPERL=1

David

On 9/22/13 7:44 PM, David Ahern wrote:
> Fixes compile failure on Fedora 12.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>   tools/perf/config/Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 6850529..85fc870 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -87,7 +87,7 @@ CFLAGS += -Wall
>   CFLAGS += -Wextra
>   CFLAGS += -std=gnu99
>
> -EXTLIBS = -lelf -lpthread -lrt -lm
> +EXTLIBS = -lelf -lpthread -lrt -lm -ldl
>
>   ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
>     CFLAGS += -fstack-protector-all
>

