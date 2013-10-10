Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3JJGTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:19:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65329 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJGTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:19:19 -0400
X-AuditID: 9c930179-b7c78ae000003065-b1-525646e697d8
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 32/52] tools/perf/build: Speed up auto-detection of features by adding a 'test-all' target
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-33-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:19:17 +0900
In-Reply-To: <1381227082-22039-33-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:11:02 +0200")
Message-ID: <87siw9ir6i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:11:02 +0200, Ingo Molnar wrote:
> +test-all:
> +	$(BUILD) -Werror -fstack-protector -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl

Also missed -Wstack-protector.  And duplicate -Werror.

Anyway, it'd be great to generate this flags as well as source file
automatically.

Thanks,
Namhyung
