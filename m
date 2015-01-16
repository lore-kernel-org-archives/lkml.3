Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbbAPK7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:59:39 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65393 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbbAPK7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:59:37 -0500
Message-ID: <54B8EF15.4000602@linaro.org>
Date: Fri, 16 Jan 2015 11:59:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] clocksource: don't suspend/resume when unused
References: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com> <1421399874-29119-3-git-send-email-alexandre.belloni@free-electrons.com> <alpine.DEB.2.11.1501161122320.5526@nanos> <20150116103530.GB3843@piout.net> <54B8EA54.5020002@linaro.org> <20150116104804.GE3843@piout.net>
In-Reply-To: <20150116104804.GE3843@piout.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 11:48 AM, Alexandre Belloni wrote:
> Hi,
>
> On 16/01/2015 at 11:39:16 +0100, Daniel Lezcano wrote :
>>> Isn't that already the case?
>>> Right now, if you call clocksource_suspend, it doesn't matter whether
>>> the clocksource has an enable or not, it will be suspended. Maybe I'm
>>> mistaken but my patch doesn't seem to change that behaviour.
>>
>> Actually, if there is no enable/disable callback, then CLOCK_SOURCE_USED
>> will be never set, hence the condition will always fail and the suspend
>> callback won't be called.
>>
>
> It is set in clocksource_enable/disable, even if there is no
> enable/disable callback.

Ah, right. But shouldn't we set the flag only if the callback is present 
and succeed as Boris mentioned it ?

> I only found direct calls to ->enable() in
> timekeeper.c, did I miss some?




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

