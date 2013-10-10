Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3JJFmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:42:50 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64668 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3JJFmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:42:49 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-d2-52563e575039
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 02/52] tools/perf/build: Add feature check core code
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-3-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 14:42:46 +0900
In-Reply-To: <1381227082-22039-3-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:32 +0200")
Message-ID: <87pprdk7ft.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue,  8 Oct 2013 12:10:32 +0200, Ingo Molnar wrote:
> +feature_check = $(eval $(feature_check_code)); $(info CHK: config/feature-checks/test-$(1))
> +define feature_check_code
> +  feature-$(2) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
> +endef
> +
> +#
> +# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
> +#
> +$(info Testing features:)
> +$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
> +$(info done)
> +
> +FEATURE_TESTS = hello
> +
> +$(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))

So as far as I can see, all the feature checking goes twice - once in
$(shell make ...) and another in $(foreach test,...).  They look like
doing exactly same thing.  And the final Makefile in this series still
has it twice.  Is it intentional or did I miss something?

Thanks,
Namhyung
