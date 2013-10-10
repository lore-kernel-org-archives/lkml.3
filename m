Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3JJFuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:50:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64727 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3JJFuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:50:12 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-4c-525640135e6d
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/52] tools/perf/build: Split out feature check: 'stackprotector'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-7-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 14:50:11 +0900
In-Reply-To: <1381227082-22039-7-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:36 +0200")
Message-ID: <87hacpk73g.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:10:36 +0200, Ingo Molnar wrote:
> -ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
> +ifeq ($(feature-stackprotector), 1)
>    CFLAGS += -Wstack-protector
>  endif

[SNIP]

> +test-stackprotector:
> +	$(BUILD) -Werror -fstack-protector

The flag being checked should be -"W"stack-protector instead of
-"f"stack-protector.  And the gcc manpage says that -Wstack-protector is
only active when -fstack-protector is active.  So the end result should
look like

	$(BUILD) -Werror -fstack-protector -Wstack-protector

Thanks,
Namhyung
