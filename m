Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaFPIPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbaFPIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:14:59 -0400
Date: Mon, 16 Jun 2014 10:09:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Simon Que <sque@chromium.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] perf: Get kernel start address by symbol name
Message-ID: <20140616080950.GA4632@krava.brq.redhat.com>
References: <1402685121-32267-1-git-send-email-sque@chromium.org>
 <20140616080649.GB1148@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140616080649.GB1148@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:06:49AM +0200, Jiri Olsa wrote:
> On Fri, Jun 13, 2014 at 11:45:21AM -0700, Simon Que wrote:
> > The function machine__get_kernel_start_addr() was taking the first symbol
> > of kallsyms as the start address. This is incorrect in certain cases
> > where the first symbol is something at 0, while the actual kernel
> > functions begin at a later point (e.g. 0x80200000).
> > 
> > This patch fixes machine__get_kernel_start_addr() to search for the
> > symbol "_text" or "_stext", which marks the beginning of kernel mapping.
> > This was already being done in machine__create_kernel_maps(). Thus, this
> > patch is just a refactor, to move that code into
> > machine__get_kernel_start_addr().
> > 
> > Change-Id: I0c38c36f5e8b0f4fb92a6f57211fa45aabe545a6
> > Signed-off-by: Simon Que <sque@chromium.org>
> 
> hi,
> looks good to me, adding Adrian to the loop

well, apart from this compile error ;-)

[jolsa@krava perf]$ make
  BUILD:   Doing 'make -j4' parallel build
  CC       util/machine.o
  SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
util/machine.c: In function ‘machine__get_kernel_start_addr’:
util/machine.c:520:6: error: ‘addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  u64 addr;
      ^
util/machine.c: In function ‘machine__process_kernel_mmap_event’:
util/machine.c:547:42: error: ‘addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
   machine->vmlinux_maps[type] = map__new2(start, kernel, type);
                                          ^
util/machine.c:520:6: note: ‘addr’ was declared here
  u64 addr;
      ^
cc1: all warnings being treated as errors
make[1]: *** [util/machine.o] Error 1
make: *** [all] Error 2


jirka
