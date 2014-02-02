Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBBQmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:42:25 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:32830 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaBBQmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:42:23 -0500
MIME-Version: 1.0
In-Reply-To: <1391340435-5130-6-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-6-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 08:42:02 -0800
Message-ID: <CALCETrVFFhBt6DyOdXdasOxb8_LHoeqkYj3C2naOBEVoPVvGxA@mail.gmail.com>
Subject: Re: [PATCH 5/8] replace VVAR(vsyscall_gtod_data) by gtod macro
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> There a currently more than 30 users of the gtod macro, so replace the
> last VVAR(vsyscall_gtod_data) by gtod macro.

Acked-by: Andy Lutomirski <luto@amacapital.net>

>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/vdso/vclock_gettime.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index fd074dd..743f277 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -109,7 +109,7 @@ static notrace cycle_t vread_pvclock(int *mode)
>                 *mode = VCLOCK_NONE;
>
>         /* refer to tsc.c read_tsc() comment for rationale */
> -       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
> +       last = gtod->clock.cycle_last;
>
>         if (likely(ret >= last))
>                 return ret;
> @@ -133,7 +133,7 @@ notrace static cycle_t vread_tsc(void)
>         rdtsc_barrier();
>         ret = (cycle_t)vget_cycles();
>
> -       last = VVAR(vsyscall_gtod_data).clock.cycle_last;
> +       last = gtod->clock.cycle_last;
>
>         if (likely(ret >= last))
>                 return ret;
> @@ -288,7 +288,7 @@ int gettimeofday(struct timeval *, struct timezone *)
>  notrace time_t __vdso_time(time_t *t)
>  {
>         /* This is atomic on x86_64 so we don't need any locks. */
> -       time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
> +       time_t result = ACCESS_ONCE(gtod->wall_time_sec);
>
>         if (t)
>                 *t = result;
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
