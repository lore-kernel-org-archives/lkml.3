Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaANHIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:08:54 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:32785 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANHIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:08:52 -0500
MIME-Version: 1.0
X-Originating-IP: [212.255.40.71]
In-Reply-To: <52D4A780.7050907@wwwdotorg.org>
References: <52D3CA6E.1010803@koalo.de>
	<52D3CB18.8040608@koalo.de>
	<52D4A780.7050907@wwwdotorg.org>
Date: Tue, 14 Jan 2014 08:08:51 +0100
Message-ID: <CABDT8WyCQK0o43wjrBbGWSAXS8gpE-sCR-g+1CC8OJMRsFyiGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] BCM2835: Add I2S driver to device tree
From: Florian Meier <florian.meier@koalo.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.01.2014 03:57, Stephen Warren wrote:
> On 01/13/2014 04:16 AM, Florian Meier wrote:
>> This adds the definitions for the BCM2835 I2S driver
>> to the device tree. Some GPIO settings are needed for
>> the correct pin functions.
>
> Patch 1/1 and the .dtsi portion of patch 2/2 look fine; I can apply
> those after 3.14's merge window closes.
>
> However, I don't think I can apply the change to bcm2835-rpi-b.dts in
> this patch; those pins are used for the board ID strapping on rev 1
> boards,

Yes, but I thought the board ID is never utilized. However, I have not
tested that.

> and even on rev 2 boards, they're simply routed to a generic
> header, rather than being dedicated for I2S usage. That part of the
> patch would be better kept locally in your own kernel tree. Perhaps if
> DT overlays ever take off, we can publish it as part of an I2S-specific
> overlay.

You are right. That might be a problem. Someone might want to use the
pins for another functionality. I personally think the I2S
functionality will be the most used functionality for those pins, but
I accept it when you say that they better should be set as second I2C
channel and generic GPIO pins (as it is by default).

However, for an end user it doesn't seem to be a convenient solution
to have a kernel tree for each possible combination of pin
assignments.
The "old way" would be to set the pin functionality while loading the
i2s driver, but I assume that is not the right way to go, right?
