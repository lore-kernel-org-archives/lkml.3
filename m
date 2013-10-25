Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3JYKHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:07:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43113 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3JYKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <3005031.0yf0g1BPEE@vostro.rjw.lan>
References: <525BD08C.2080101@t-online.de>
	<2582195.phiuskXt0x@vostro.rjw.lan>
	<1483174.NsuFf8aJk6@vostro.rjw.lan>
	<3005031.0yf0g1BPEE@vostro.rjw.lan>
Date: Fri, 25 Oct 2013 11:07:40 +0100
X-Google-Sender-Auth: Y7cJhZQQZ05CyYdzc-7HFTgAYes
Message-ID: <CA+55aFy3dFGsN_Ckaq8egmaEi_JV_qAVOjR6h3gojyBWwA-jpA@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:10 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, October 25, 2013 11:51:40 AM Rafael J. Wysocki wrote:
>
>         /* don't keep reloading if cpufreq_driver exists */
>         if (cpufreq_get_current_driver())
> -               return 0;
> +               return -EEXIST;
>
>         if (acpi_disabled)
> -               return 0;
> +               return -ENODEV;
>
>         pr_debug("acpi_cpufreq_init\n");

I think:

 - EBUSY is a better error return than EEXIST here/

  - do the ENODEV case first, because claiming something is busy when
you couldn't have used it anyway is kind of stupid)

but yeah, this looks like the right thing. Let's make sure there
aren't any annoying error messages etc printed out as a result of
this, though.

                  Linus
