Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaI1MA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:00:59 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39000 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaI1MA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140928103301.GN27755@sirena.org.uk>
References: <1411834906-9533-1-git-send-email-romain.perier@gmail.com>
	<20140928103301.GN27755@sirena.org.uk>
Date: Sun, 28 Sep 2014 14:00:54 +0200
Message-ID: <CABgxDo+h2AYjAO4darK4+RTXqnhf4OqouGLfF2yuJCpu7r6tLg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] regulator: act8865: Add support to turn off all outputs
From: PERIER Romain <romain.perier@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


2014-09-28 12:33 GMT+02:00 Mark Brown <broonie@kernel.org>:
> On Sat, Sep 27, 2014 at 04:21:44PM +0000, Romain Perier wrote:
>> When the property "active-semi,system-power-controller" is found in the
>> devicetree, the function pm_power_off is defined. This function sends the
>> rights bit fields to the global off control register. shutdown/poweroff
>> commands are now supported for hardware components which use these PMU.
>
> We really need to come up with a standard property for this and document
> it rather than continuing to add individual device specific properties
> all doing the same thing, and probably also some helper code and/or a
> standard operation for this - there's a lot of drivers implementing the
> same pattern here.

I completly agree about adding a unified and generic property for that purpose.
I already proposed something for that on devicetree ML, see the thread
"Proposal: generic property for system-power-controller".
Unfortunately I did not get replies :) .


>
>> +     if (dev->of_node &&
>> +         of_property_read_bool(dev->of_node,
>> +                               "active-semi,system-power-controller")) {
>> +             act8865_i2c_client = client;
>
> Indentation seems messed up here - tabs vs spaces?

Yes, I really don't understand where the problem is. I use good emacs
settings to be compatible with kernel coding style and git diff does
not show me indent/spaces problems :/ .
Sorry because this is a very boring issue when reviewing patches... I
will investigate ^^

Romain
