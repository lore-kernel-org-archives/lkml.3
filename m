Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JYNuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:50:00 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59693 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3JYNt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:49:58 -0400
MIME-Version: 1.0
In-Reply-To: <1529148.xq0P7G6L83@vostro.rjw.lan>
References: <525BD08C.2080101@t-online.de>
	<3005031.0yf0g1BPEE@vostro.rjw.lan>
	<CA+55aFy3dFGsN_Ckaq8egmaEi_JV_qAVOjR6h3gojyBWwA-jpA@mail.gmail.com>
	<1529148.xq0P7G6L83@vostro.rjw.lan>
Date: Fri, 25 Oct 2013 19:19:57 +0530
Message-ID: <CAKohpo=QV831nP1WcdrWRCB7vkAtKPiSvSujbeE3usM+LCZpTg@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2013 16:40, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> ---
>  drivers/cpufreq/acpi-cpufreq.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> Index: linux-pm/drivers/cpufreq/acpi-cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/acpi-cpufreq.c
> +++ linux-pm/drivers/cpufreq/acpi-cpufreq.c
> @@ -986,12 +986,12 @@ static int __init acpi_cpufreq_init(void
>  {
>         int ret;
>
> +       if (acpi_disabled)
> +               return -ENODEV;
> +
>         /* don't keep reloading if cpufreq_driver exists */
>         if (cpufreq_get_current_driver())
> -               return 0;
> -
> -       if (acpi_disabled)
> -               return 0;
> +               return -EEXIST;
>
>         pr_debug("acpi_cpufreq_init\n");

Even better,

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
