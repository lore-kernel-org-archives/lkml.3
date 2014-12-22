Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaLVO42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaLVO40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:56:26 -0500
Date: Mon, 22 Dec 2014 15:56:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Message-ID: <20141222145610.GD29096@krava.brq.redhat.com>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 01:51:05PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> color_parse_mem() color_parse()
> 
> This was partially found by using a static code analysis program called cppcheck.

and partially removed ;-)

[jolsa@krava perf]$ make
  BUILD:   Doing 'make -j4' parallel build
  CC       util/debug.o
  CC       util/color.o
  CC       util/machine.o
  CC       util/map.o
util/color.c:8:12: error: ‘parse_color’ defined but not used [-Werror=unused-function]
 static int parse_color(const char *name, int len)
            ^
util/color.c:28:12: error: ‘parse_attr’ defined but not used [-Werror=unused-function]
 static int parse_attr(const char *name, int len)
            ^
cc1: all warnings being treated as errors
make[1]: *** [util/color.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2


any clue why this (color name parsing) is in?

thanks,
jirka
