Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaEUXke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:40:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54350 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752306AbaEUXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:40:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
Date: Thu, 22 May 2014 01:57:29 +0200
Message-ID: <2173444.bOnmhZJafF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpokaBo96h4axsntJz8b6q9VE7Z_GfQvfuQ85HEFi8r4V4w@mail.gmail.com>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org> <4765191.0FhyvSGyvF@vostro.rjw.lan> <CAKohpokaBo96h4axsntJz8b6q9VE7Z_GfQvfuQ85HEFi8r4V4w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2014 08:08:11 AM Viresh Kumar wrote:
> On 20 May 2014 02:43, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > What about
> >
> >         if (error)
> >                 return error;
> >
> > and then you'd save an indentation level?
> 
> Yes.
> 
> > Anyway, I find adding of_node* stuff directly to the driver core this way
> > kind of disgusting as there still are platforms that don't use it.
> >
> > Can we have a call to a function that will change into an empty stub on such
> > platforms here, please?
> 
> Okay. But can you explain a bit more about how and where those stubs
> would be implemented?

In a header file included by cpu.c.  Something like

#if defined(CONFIG_OF) && defined(CONFIG_PM_OPP)
<function header>
#else
static inline <stub>
#endif


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
