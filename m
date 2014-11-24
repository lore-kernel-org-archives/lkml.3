Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaKXVJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:09:11 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63122 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKXVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:09:09 -0500
Message-ID: <54739E6D.2010702@linaro.org>
Date: Mon, 24 Nov 2014 21:09:01 +0000
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
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc3 v8 1/4] irqchip: gic: Make gic_raise_softirq()
 FIQ-safe
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411241918090.6439@nanos> <alpine.DEB.2.11.1411241928300.6439@nanos> <547396D0.5030309@linaro.org> <alpine.DEB.2.11.1411242139240.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411242139240.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/14 20:41, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Daniel Thompson wrote:
>> I did want to remove the lock too. However when I reviewed this code I
>> concluded the lock was still required. Without it I think it is possible
>> for gic_raise_softirq() to raise an IPI on the old core *after* the code
>> to migrate pending IPIs has been run.
> 
> And I bet it took you quite some time to figure that out from that
> overly documented abuse of irq_controller_lock. See my other reply.

Yes. It did take quite some time, although compared to some of the other
FIQ/NMI-safety reviews I've been doing recently it could be worse. ;-)

