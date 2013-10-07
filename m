Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3JGOwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:52:25 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50789 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3JGOwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:52:23 -0400
Message-ID: <5252CA9D.3000805@gmail.com>
Date: Mon, 07 Oct 2013 08:52:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 20/50] tools/perf/build: Split out feature check: 'libslang'
References: <1381147003-2574-1-git-send-email-mingo@kernel.org> <1381147003-2574-21-git-send-email-mingo@kernel.org>
In-Reply-To: <1381147003-2574-21-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/13 5:56 AM, Ingo Molnar wrote:

> @@ -283,7 +283,7 @@ endif
>
>   ifndef NO_GTK2
>     FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
> -  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
> +  ifneq ($(feature-gtk2), 1)
>       msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
>       NO_GTK2 := 1
>     else

Looks like the gtk2 change bled in early. this should be with the next 
patch.

David

