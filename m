Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaBWWMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:12:40 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53824 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaBWWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:12:39 -0500
Message-ID: <530A7252.9070200@gmail.com>
Date: Sun, 23 Feb 2014 23:12:34 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/16] pinctrl: mvebu: restructure resource allocation
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com> <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140223220610.GA14250@titan.lakedaemon.net>
In-Reply-To: <20140223220610.GA14250@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 11:06 PM, Jason Cooper wrote:
> On Sun, Feb 23, 2014 at 03:20:58PM +0100, Sebastian Hesselbarth wrote:
>> This patch set restructures the common pinctrl driver part of mvebu
>> to allow SoC specific controls to handle their own resources. Currently,
>> the common driver maps a single resource passed by DT while the SoC
>> specific controls cannot access that resource. To achieve the removal
>> of knowledge of resources in the common driver, we first need to rework
>> how SoC specific and common get/set callbacks are handled.
>>
>> The patch set is based on three patch sets sent earlier [1][2][3] but drops
>> any Dove specific removal of hardcoded addresses. This allows to have
>> a clear view on the structural changes now and Dove specific changes
>> later on. The Dove specific patches will be re-sent on top of this one,
>> as soon as we are all happy with the resource allcation restruturing.
>>
>> Also, in the meantime, pinctrl driver stubs for new Armada 375/38x have
>> been posted [4]. Compared to v3, this patch set now also takes care of
>> the new pinctrl stubs for Armada 375/38x. Those patches have been provided
>> by Thomas Petazzoni and make this patches depend on them. We have no stable
>> branch for the Armada 375/38x pinctrl patches but I guess Jason will provide
>> one soon.
>
> Ok, I've applied this to mvebu/pinctrl with a dependency on
> mvebu/pinctrl-3xx.  So this'll be in -next tonight and hopefully we'll
> have an ideal in a few days which tree we'll send it through.

Great, thanks! I'll prepare Dove cleanup on top tomorrow. Unfortunately,
Dove-to-mvebu progress will also depend on it. If you are unhappy
with the triple dependency we can postpone it for v3.16 but I think it
should be relatively easy to handle.

Sebastian

