Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3F1RHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:07:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45072 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3F1RHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:07:00 -0400
Message-ID: <51CDC2B3.1030907@codeaurora.org>
Date: Fri, 28 Jun 2013 10:06:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stehle Vincent-B46079 <B46079@freescale.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/13 09:58, Stehle Vincent-B46079 wrote:
> From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Stephen Boyd
> (..)
>> Do you have debug_ll support to get some serial logs?
> Hi,
>
> Thanks for your concern on the matter. You are right, there is debug_ll support for i.MX6. If I activate it for next-20130628 imx_v6_v7_defconfig, that only "buys" me one additional line, though:
>
>   Uncompressing Linux... done, booting the kernel.

Oh and also add earlyprintk to the command line and enable the
earlyprintk config. It should buy you some more lines.

>
>> Also could you try booting with maxcpus=1 on the kernel commandline?
> Good idea; it goes much further with this one (until it crashes in wm8962_probe(), which is as far as I go when I revert 064706514ec3fea740c2656e03c4f01f6a551ac4).

Interesting. Thanks for the test.

>
>> And it would be useful to have the output of /proc/timer_list if you have it from a working device.
> Sure; I pasted it below.

Is this an SMP capable device? What devicetree blob are you using?

>
>> I believe you have a per-cpu TWD timer and a global imx-gpt?
> I think you are right from what I see in /proc/interrupts.

Well oddly I don't see any twd in the timer list but that may be because
you're not running more than one CPU? It would be good to get the output
when you run SMP if it has that support.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

