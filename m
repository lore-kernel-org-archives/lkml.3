Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3JJGA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:00:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55722 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3JJGAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:00:25 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-af-525642783e6b
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 15/52] tools/perf/build: Split out feature check: 'libelf-mmap'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-16-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:00:24 +0900
In-Reply-To: <1381227082-22039-16-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:45 +0200")
Message-ID: <8761t5k6mf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:10:45 +0200, Ingo Molnar wrote:
> @@ -202,7 +203,7 @@ ifndef NO_LIBELF
>    CFLAGS += -DHAVE_LIBELF_SUPPORT
>    FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
>  
> -  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
> +  ifeq ($(feature-libelf-mmap), 1)
>      CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
>    endif
>  
> @@ -227,8 +228,7 @@ endif # NO_LIBELF
>  
>  ifndef NO_LIBELF
>    CFLAGS += -DHAVE_LIBELF_SUPPORT
> -  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
> -  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
> +  ifeq ($(feature-libelf-mmap), 1)
>      CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
>    endif # try-cc
>  endif # NO_LIBELF

As Ulrich Drepper reported, it seems that this hunk is duplicate.

Thanks,
Namhyung
