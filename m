Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaFBTzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:55:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:5404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaFBTzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="550420649"
Date: Mon, 2 Jun 2014 04:54:57 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Javi Merino" <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] tools/thermal: tmon: fix compilation errors when
 building statically
Message-ID: <20140602045457.6b519e43@jacob-desktop>
In-Reply-To: <1401728897-25188-1-git-send-email-javi.merino@arm.com>
References: <1401728897-25188-1-git-send-email-javi.merino@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 18:08:17 +0100
"Javi Merino" <javi.merino@arm.com> wrote:

> tmon fails to build statically with the following error:
> 
> $ make LDFLAGS=-static
> gcc -O1 -Wall -Wshadow -W -Wformat -Wimplicit-function-declaration
> -Wimplicit-int -fstack-protector -D VERSION=\"1.0\" -static tmon.o
> tui.o sysfs.o pid.o   -o tmon -lm -lpanel -lncursesw  -lpthread
> tmon.o: In function `tmon_sig_handler': tmon.c:(.text+0x21):
> undefined reference to `stdscr' tmon.o: In function `tmon_cleanup':
> tmon.c:(.text+0xb9): undefined reference to `stdscr'
> tmon.c:(.text+0x11e): undefined reference to `stdscr'
> tmon.c:(.text+0x123): undefined reference to `keypad'
> tmon.c:(.text+0x12d): undefined reference to `nocbreak' tmon.o: In
> function `main': tmon.c:(.text+0x785): undefined reference to `stdscr'
> tmon.c:(.text+0x78a): undefined reference to `nodelay'
> tui.o: In function `setup_windows':
> tui.c:(.text+0x131): undefined reference to `stdscr'
> tui.c:(.text+0x176): undefined reference to `stdscr'
> tui.c:(.text+0x19f): undefined reference to `stdscr'
> tui.c:(.text+0x1cc): undefined reference to `stdscr'
> tui.c:(.text+0x1ff): undefined reference to `stdscr'
> tui.o:tui.c:(.text+0x229): more undefined references to `stdscr'
> follow tui.o: In function `show_cooling_device':
> [...]
> 
> stdscr() and friends are in libtinfo (part of ncurses) so add it to
> the libraries that are linked in when compiling tmon to fix it.
> 
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Thanks,

Jacob
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  tools/thermal/tmon/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/thermal/tmon/Makefile b/tools/thermal/tmon/Makefile
> index 447321104ec0..e775adcbd29f 100644
> --- a/tools/thermal/tmon/Makefile
> +++ b/tools/thermal/tmon/Makefile
> @@ -21,7 +21,7 @@ OBJS = tmon.o tui.o sysfs.o pid.o
>  OBJS +=
>  
>  tmon: $(OBJS) Makefile tmon.h
> -	$(CC) ${CFLAGS} $(LDFLAGS) $(OBJS)  -o $(TARGET) -lm -lpanel
> -lncursesw  -lpthread
> +	$(CC) ${CFLAGS} $(LDFLAGS) $(OBJS)  -o $(TARGET) -lm -lpanel
> -lncursesw -ltinfo -lpthread 
>  valgrind: tmon
>  	 sudo valgrind -v --track-origins=yes --tool=memcheck
> --leak-check=yes --show-reachable=yes --num-callers=20
> --track-fds=yes ./$(TARGET)  1> /dev/null

[Jacob Pan]
