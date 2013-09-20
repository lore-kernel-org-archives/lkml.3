Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3ITPk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:40:26 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61504 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3ITPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:40:25 -0400
MIME-Version: 1.0
In-Reply-To: <523C6A88.30800@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com>
	<523C6A88.30800@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 17:40:24 +0200
Message-ID: <CACRpkdasfW9OzZHPgfksjkHgw+Z-n7Tc_d2yXYy+BjShUhAYFg@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 5:32 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/20/2013 08:51 PM, Linus Walleij wrote:

>> sa11x0_pcmcia_init() which starts this chain of events is called as
>> an fs_initcall(), see drivers/pcmcia/sa1100_generic.c
>
> But fs_initcall() comes after arch_initcall() right? (looking at
> include/linux/init.h). Since the corresponding cpufreq-driver (drivers/
> cpufreq/sa1100-cpufreq.c) uses arch_initcall() to register itself, it
> is all the more surprising how this could happen...

Hm it does happen if the cpufreq driver does not probe *at all*
right? I will look closer at this, maybe it just doesn't register
properly for some SA1100 variants...

Yours,
Linus Walleij
