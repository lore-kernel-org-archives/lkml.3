Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbbALLJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:09:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbbALLJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:09:36 -0500
Date: Mon, 12 Jan 2015 12:09:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: acme@redhat.com, namhyung@kernel.org, peterz@infradead.org,
        jolsa@kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH v2 3/5] perf tools: [uclibc] Avoid build splat for
 syscall numbers
Message-ID: <20150112110907.GD26229@krava.redhat.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-4-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420888254-17504-4-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 04:40:52PM +0530, Vineet Gupta wrote:
> This is due to duplicated unistd inclusion (via uClibc headers + kernel headers)
> Also seen on ARM uClibc based tools
> 
> ------- ARC build ---------->8-------------
> 
>   CC       util/evlist.o
> In file included from
> ~/arc/k.org/arch/arc/include/uapi/asm/unistd.h:25:0,
>                  from util/../perf-sys.h:10,
>                  from util/../perf.h:15,
>                  from util/event.h:7,
>                  from util/event.c:3:
> ~/arc/k.org/include/uapi/asm-generic/unistd.h:906:0:
> warning: "__NR_fcntl64" redefined [enabled by default]
>  #define __NR_fcntl64 __NR3264_fcntl
>  ^
> In file included from
> ~/arc/gnu/INSTALL_1412-arc-2014.12-rc1/arc-snps-linux-uclibc/sysroot/usr/include/sys/syscall.h:24:0,
>                  from util/../perf-sys.h:6,
> ----------------->8-------------------
> 
> ------- ARM build ---------->8-------------
> 
>   CC FPIC  plugin_scsi.o
> In file included from util/../perf-sys.h:9:0,
>                  from util/../perf.h:15,
>                  from util/cache.h:7,
>                  from perf.c:12:
> ~/arc/k.org/arch/arm/include/uapi/asm/unistd.h:28:0:
> warning: "__NR_restart_syscall" redefined [enabled by default]
> In file included from
> ~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/sys/syscall.h:25:0,
>                  from util/../perf-sys.h:6,
>                  from util/../perf.h:15,
>                  from util/cache.h:7,
>                  from perf.c:12:
> ~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/bits/sysnum.h:17:0:
> note: this is the location of the previous definition
> ----------------->8-------------------

Could you please point out what's the right logic for including those headers?

I've always thought that just adding:

  #include <linux/unistd.h>

should be safe no matter what.. feels like bug in one of those
header files? (uClibc headers & kernel headers)

thanks for info,
jirka
