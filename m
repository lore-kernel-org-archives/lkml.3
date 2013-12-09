Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352Ab3LIRRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab3LIRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:17:33 -0500
Date: Mon, 9 Dec 2013 18:17:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
Message-ID: <20131209171719.GA16631@krava.brq.redhat.com>
References: <1386411461-21510-1-git-send-email-jean.pihet@linaro.org>
 <1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 11:17:41AM +0100, Jean Pihet wrote:
> Use the per-feature check flags for the unwinding feature in order
> to correctly compile the libunwind and libunwind-debug-frame feature
> checks.
> 
> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
> in 'make -C tools/perf'
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

SNIP

> +BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
>  
>  ###############################
>  
>  test-all:
> -	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
> +	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl

hum, the test-all build command should have every possible flags we use, right?
including LIBUNWIND_CFLAGS, LIBUNWIND_LDFLAGS

also, this patch no longer applies on acme's perf/core

jirka
