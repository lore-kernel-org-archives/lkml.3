Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaCZAA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:00:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55414 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaCZAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:00:54 -0400
Message-ID: <5332188E.7050302@ahsoftware.de>
Date: Wed, 26 Mar 2014 01:00:14 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Capella <sebastian.capella@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Nicolas Pitre <nico@linaro.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>	<20140316070917.GA3094@arch.cereza>	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>	<20140317204410.GA1118@arch.cereza>	<CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>	<20140319154434.GA3488@arch.cereza>	<CADHgK6vLB3h0zrdpve=ZyjNu2pe1VYsGxrYgv=2C-JV37vE9tQ@mail.gmail.com> <CADHgK6vkwjXyJxRcOXjJpJJaR0-YR869NpPZ+CBBS8kEdE0qCQ@mail.gmail.com> <5331CD43.1010601@ahsoftware.de> <53321311.8060604@ahsoftware.de>
In-Reply-To: <53321311.8060604@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.03.2014 00:36, schrieb Alexander Holler:
> Am 25.03.2014 19:38, schrieb Alexander Holler:
>
>> reboot too. Another solution would be to unregister the reboot_notifier
>> in the reboot_nofifier itself. I've just seen one watchdog driver
>> (drivers/rtc/rtc-m41t80.c) which does that. But I still think such
>
> That, btw. is broken. ;)
>
> Right after having send the mail, I've became that intuition, had a look
> and ... notifier.h does state the following:
>
>   * atomic_notifier_chain_unregister(),
> blocking_notifier_chain_unregister(),
>   * and srcu_notifier_chain_unregister() _must not_ be called from within
>   * the call chain.
>
> (The reboot-notifier chain is of type blocking_notifier_chain)
>
> So I've picked up one user of reboot_notifier by random and had the luck
> to choose a broken one. ;)
>
> I will make a patch and will have a look if the same failure can be
> found elsewhere. There aren't that much users of the reboot-notifier, so
> it shouldn't cost me that much time.

Hmm, and either I was confused, or have looked at some other user of the 
reboot_notifier, but rtc-m41t80.c doesn't call unregister from it's 
notifier. And unfortunately there are a bit more users of the 
reboot_notifier than I first thought. :/

I will check if I can find out at least at which driver I had a look at 
which did call unregister_notifier from the notifier itself.

Regards,

Alexander Holler

