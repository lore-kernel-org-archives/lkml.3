Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaHETwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:52:25 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:42564 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbaHETwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <1407256036-18658-1-git-send-email-bobby.prani@gmail.com>
References: <1407256036-18658-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 5 Aug 2014 15:51:50 -0400
Message-ID: <CAJhHMCCGEXq17L4ovjOdRWuJ++ShDQTA4+H8VOTx=kF_Qd2Sag@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: lustre: Remove circular dependency on header
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Joe Perches <joe@perches.com>, Oleg Drokin <green@linuxhacker.ru>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Cc: geert@linux-m68k.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please note, this also fixes the following build error on sparc64

http://kisskb.ellerman.id.au/kisskb/buildresult/11607883/

On Tue, Aug 5, 2014 at 12:27 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> The following patch fixes a build error on sparc32. I think it should go to
> stable 3.16.
>
> Remove a circular dependency on atomic.h header file which leads to compilation
> failure on sparc32 as reported here:
> http://kisskb.ellerman.id.au/kisskb/buildresult/11340509/
>
> The specific dependency is as follows:
>
> In file included from arch/sparc/include/asm/smp_32.h:24:0,
>                  from arch/sparc/include/asm/smp.h:6,
>                  from arch/sparc/include/asm/switch_to_32.h:4,
>                  from arch/sparc/include/asm/switch_to.h:6,
>                  from arch/sparc/include/asm/ptrace.h:84,
>                  from arch/sparc/include/asm/processor_32.h:16,
>                  from arch/sparc/include/asm/processor.h:6,
>                  from arch/sparc/include/asm/barrier_32.h:4,
>                  from arch/sparc/include/asm/barrier.h:6,
>                  from arch/sparc/include/asm/atomic_32.h:17,
>                  from arch/sparc/include/asm/atomic.h:6,
>                  from drivers/staging/lustre/lustre/obdclass/class_obd.c:38
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: stable@vger.kernel.org
> ---
>  drivers/staging/lustre/lustre/obdclass/class_obd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> index 8b19f3c..701c6a7 100644
> --- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
> +++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> @@ -35,7 +35,7 @@
>   */
>
>  #define DEBUG_SUBSYSTEM S_CLASS
> -# include <asm/atomic.h>
> +# include <linux/atomic.h>
>
>  #include "../include/obd_support.h"
>  #include "../include/obd_class.h"
> --
> 1.9.1
>



-- 
Pranith
