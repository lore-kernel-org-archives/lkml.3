Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaJTNKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:10:39 -0400
Received: from li271-223.members.linode.com ([178.79.152.223]:40021 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaJTNKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:10:35 -0400
Message-ID: <544509C7.9010309@mleia.com>
Date: Mon, 20 Oct 2014 16:10:31 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 1/2] pwm: Add Allwinner SoC support
References: <1413743305-1979-1-git-send-email-alexandre.belloni@free-electrons.com> <1413743305-1979-2-git-send-email-alexandre.belloni@free-electrons.com> <54442BB1.1080403@mleia.com> <20141020102939.GB10616@piout.net>
In-Reply-To: <20141020102939.GB10616@piout.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20141020_141033_454691_845A3024 
X-CRM114-Status: GOOD (  12.28  )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On 20.10.2014 13:29, Alexandre Belloni wrote:
> Hi,
> 
> On 20/10/2014 at 00:22:57 +0300, Vladimir Zapolskiy wrote :
>>> +struct sun4i_pwm_chip {
>>> +	struct pwm_chip chip;
>>> +	struct clk *clk;
>>> +	void __iomem *base;
>>> +	struct mutex ctrl_lock;
>>
>> why do you use mutex? I haven't found any blocking subcalls under
>> protection, a spinlock seems to fit better here.
>>
> 
> A mutex here will do the right thing. The lock is never taken in
> interrupt context and a mutex is spinning for a few cycles before
> putting the thread to sleep.

and why do you want to put a thread to sleep in context of the driver?

> I'm not sure why you feel a spinlock would be better here.
> 

Only because a spinlock is lighter than a mutex.

With best wishes,
Vladimir
