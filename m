Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3HUXE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:04:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36595 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3HUXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:04:23 -0400
MIME-Version: 1.0
In-Reply-To: <5214FCB6.4040200@wwwdotorg.org>
References: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
	<52127035.7000909@wwwdotorg.org>
	<5214FCB6.4040200@wwwdotorg.org>
Date: Thu, 22 Aug 2013 01:04:23 +0200
Message-ID: <CACRpkdbNh6ooBh-dhT=KKHQMZ=uK_AQMsreTg56kVXE5cE1ohQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: queue GPIO operations instead of defering
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 7:45 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/19/2013 01:21 PM, Stephen Warren wrote:
>> On 08/17/2013 08:56 AM, Linus Walleij wrote:
>>> We currently defer probing of the caller if a pinctrl GPIO
>>> request or direction setting comes in before the range mapping
>>> a certain GPIO to a certain pin controller is available.
>>>
>>> This can end up with a circular dependency: the GPIO driver
>>> needs the pin controller to be ready and the pin controller
>>> need the GPIO driver to be ready. This also happens if
>>> pin controllers and GPIO controllers compiled as modules
>>> are inserted in a certain order.
>>>
>>> To break this circular dependence, queue any GPIO
>>> operations coming to the framework until the range is ready,
>>> instead of deferring the probe of the caller.
>>
>> I just noticed that next-20130819 is failing on the Tegra114 Dalmore
>> board because of this patch. The kernel log is below. Reverting this
>> patch solves the problem
>
> Linus, any thoughts here?

None whatsoever, but logically it should be that your pinctrl+GPIO
driver pair depends on the GPIO driver coming first and having it's probing
deferred.

I'll rip out that patch for the time being...

Yours,
Linus Walleij
