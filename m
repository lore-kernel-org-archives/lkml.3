Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbaLVSAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:00:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52568 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbaLVSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:00:03 -0500
Message-ID: <54985C30.7020605@wwwdotorg.org>
Date: Mon, 22 Dec 2014 11:00:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Joseph Lo <josephl@nvidia.com>
CC: stable@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Use PMC scratch register 40 for tegra_resume()
 location store
References: <1419202392-1159-1-git-send-email-digetx@gmail.com> <54984429.8040905@wwwdotorg.org> <5498549B.8070101@gmail.com>
In-Reply-To: <5498549B.8070101@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 10:27 AM, Dmitry Osipenko wrote:
> 22.12.2014 19:17, Stephen Warren пишет:
>> On 12/21/2014 03:52 PM, Dmitry Osipenko wrote:
>>> Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed
>>> tegra_resume()
>>> location storing from late to early and as result broke suspend on tegra20.
>>> PMC scratch register 41 was used by tegra lp1 suspend core code for storing
>>> physical memory address of common resume function and in the same time used by
>>> tegra20 cpuidle driver for storing cpu1 "resettable" status, so it implied
>>> strict order of scratch register use. Fix it by using scratch 40 instead of 41
>>> for tegra_resume() location store.
>>
>> You likely can't simply change the PMC scratch register usage arbitrarily;
>> specific registers are designated for specific purposes, and code outside the
>> Linux kernel (bootloaders, LP0 resume code, secure monitors, etc.) may depend on
>> those specific values being in those registers. Without significant research,
>> I'd suggest not changing the PMC scratch register usage.
>
> Sure, that's why I asked to verify if scratch register 40 is in use in the
> comment after commit message.

Sorry, I didn't notice that.

> I've checked that u-boot doesn't use it (since
> upstream kernel doesn't care about any other bootloader), but no idea about
> secure monitor. It's definitely safer to avoid changing scratch regs usage, I
> thought that proposed solution would be best from the pure code point of view.
> So, I'm considering your answer as a rejection of the patch (please, let me know
> if I'm wrong) and will prepare another one. Btw, it would be nice to have
> scratch registers usage publicly documented somewhere (on "Tegra Public
> Application Notes" webpage for example), if it's possible, of course.

At this stage in Tegra20 development, I think it'd be best to avoid 
changing any scratch register usage if at all possible.

