Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaK1KPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:15:14 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34189 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK1KPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:15:09 -0500
Message-ID: <54784B23.9040604@linaro.org>
Date: Fri, 28 Nov 2014 10:14:59 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc4 v11 2/6] irqchip: gic: Optimize locking in gic_raise_softirq
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-3-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411272231450.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411272231450.3961@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 21:37, Thomas Gleixner wrote:
> On Thu, 27 Nov 2014, Daniel Thompson wrote:
> 
>> Currently gic_raise_softirq() unconditionally takes and releases a lock
>> whose only purpose is to synchronize with the b.L switcher.
>>
>> Remove this lock if the b.L switcher is not compiled in.
> 
> I think the patches are in the wrong order. We optimize for the sane
> use case first, i.e BL=n. So you want to make the locking of
> irq_controller_lock in gic_raise_softirq() conditional in the first
> place, which should have been done when this was introduced.
>
> Once you have isolated that you can apply your split lock patch for
> the BL=y nonsense.
> 
> Adding more locks first and then optimizing them out does not make any
> sense.

You original described the use of irq_controller_lock for its current
dual purpose to be an abuse of the lock. Does it really make more sense
to optimize before we correct the abuse?

How about just squashing them together? It reduces the combined diffstat
by ~10%...


Daniel.
