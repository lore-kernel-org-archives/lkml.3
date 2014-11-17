Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaKQS0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:26:05 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49042 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaKQS0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:26:02 -0500
From: Kevin Hilman <khilman@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<7ha93t8z1q.fsf@deeprootsystems.com>
	<CAMuHMdVrpwg2pYxUhA5oRgd1g2DmLuSb2jR3ywz8hkjms7UBcw@mail.gmail.com>
	<6465990.KKns6W8hQE@vostro.rjw.lan>
Date: Mon, 17 Nov 2014 10:25:58 -0800
In-Reply-To: <6465990.KKns6W8hQE@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Mon, 17 Nov 2014 02:22:52 +0100")
Message-ID: <7hioid3cqx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

> On Saturday, November 15, 2014 01:32:01 PM Geert Uytterhoeven wrote:
>> Hi Kevin,
>> 
>> On Fri, Nov 14, 2014 at 6:36 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> >> On Thu, Nov 13, 2014 at 11:28 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> >>> It makes little sense to use generic power domains without runtime PM.
>> >>
>> >> Does it?
>> >> It still powers down the PM domains on system suspend (at least on my
>> >> boards ;-)
>> >
>> > Sure, but your devices are also using runtime PM, so I'm not sure how
>> > does that change my statement above?
>> 
>> I do mean with CONFIG_PM_RUNTIME turned off.
>> 
>> If PM domain support is disabled, s2ram will not power down the PM domains.
>
> But if PM_RUNTIME is enabled along with it, I don't think it will make much
> of a different, will it?
>
> Building the kernel with genpd and without PM_RUNTIME is possible today,
> but is it really useful?  To me, it only seems to make people try to
> reinvent the wheel "because PM_RUNTIME may be unset".
>
> I have to say I'm seriously considering to make PM_SLEEP select
> PM_RUNTIME too as that would make quite a few things a *lot* simpler.

Yes.  

If that were the case, we woudn't need the pm_runtime_force_* calls
either.

Kevin
