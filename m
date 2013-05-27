Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3E0IPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:15:03 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54750 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3E0IPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <1369641266-16913-1-git-send-email-icycoder@gmail.com>
References: <1369641266-16913-1-git-send-email-icycoder@gmail.com>
Date: Mon, 27 May 2013 16:15:00 +0800
Message-ID: <CAPQBkrOtJkn_M+7hBJC-amxZ7SHQ+E_7gf2XiVzxCBbeEkxapw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix a wrong header file path in util/unwind.c
From: Runzhen Wang <icycoder@gmail.com>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I made a mistake.....
There is no bug,  please ignore my patch.
Sorry again. I will be careful next time.

On Mon, May 27, 2013 at 3:54 PM, Runzhen Wang <icycoder@gmail.com> wrote:
> For the latest perf core tree:
> (git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git),
> in util/unwind.c line 29 includes "perf_regs.h". That means compiler
> will search for this header file in current directory, so, gcc will
> puts the following error messages:
>
> util/unwind.c: In function ‘access_mem’:
> util/unwind.c:400:50: error: ‘PERF_REG_SP’ undeclared (first use in this
> function)
> util/unwind.c:400:50: note: each undeclared identifier is reported only
> once for each function it appears in
> util/unwind.c: In function ‘unwind__get_entries’:
> util/unwind.c:562:41: error: ‘PERF_REG_IP’ undeclared (first use in this
> function)
>
> Changing #include "perf_regs.h" to #include <perf_regs.h> will fix the
> error.
>
> Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
> ---
>  tools/perf/util/unwind.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> index 958723b..50e14f7 100644
> --- a/tools/perf/util/unwind.c
> +++ b/tools/perf/util/unwind.c
> @@ -26,7 +26,7 @@
>  #include <libunwind-ptrace.h>
>  #include "thread.h"
>  #include "session.h"
> -#include "perf_regs.h"
> +#include <perf_regs.h>
>  #include "unwind.h"
>  #include "util.h"
>
> --
> 1.7.9.5
>
