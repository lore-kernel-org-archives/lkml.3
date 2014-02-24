Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaBXRXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:23:53 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61466 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaBXRXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140223051209.GK25940@sirena.org.uk>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
	<20140223051209.GK25940@sirena.org.uk>
Date: Mon, 24 Feb 2014 14:23:50 -0300
Message-ID: <CAOMZO5BPvCcx_f09Khuw8MVxrR18fnv9e1xeuJ0c_8G22AR53g@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>, Sascha Hauer <kernel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 2:12 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Feb 20, 2014 at 05:36:02PM +0100, Markus Pargmann wrote:
>> Hi,
>>
>> These two patches replace all ops->enable/disable by
>> _regulator_do_disable/enable function calls. These wrappers also handle gpio
>> regulators.
>
> Applied both, thanks.

With these two patches applied I get the following error on
mx6qsabresd running today's linux-next:

vdd1p1: failed to enable
anatop_regulator regulator-1p1.2: failed to register vdd1p1
anatop_regulator: probe of regulator-1p1.2 failed with error -22
vdd3p0: failed to enable
anatop_regulator regulator-3p0.3: failed to register vdd3p0
anatop_regulator: probe of regulator-3p0.3 failed with error -22
vdd2p5: failed to enable
anatop_regulator regulator-2p5.4: failed to register vdd2p5
anatop_regulator: probe of regulator-2p5.4 failed with error -22
vddarm: 725 <--> 1450 mV at 1100 mV
vddpu: 725 <--> 1450 mV at 1100 mV
vddsoc: 725 <--> 1450 mV at 1175 mV
....

pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
pfuze100-regulator 1-0008: FAB: 0, FIN: 0
SW1AB: failed to enable
pfuze100-regulator 1-0008: register regulatorSW1AB failed
pfuze100-regulator: probe of 1-0008 failed with error -22


Reverting these two patches the regulators probe successfully.

Any ideas?

Regards,

Fabio Estevam
