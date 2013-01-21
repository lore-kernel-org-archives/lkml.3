Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3AUX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:59:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37031 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3AUX7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:59:22 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: RE: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Thread-Topic: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Thread-Index: AQHN8fhzdUVzsipdnka7A7zmYXiw6phIDtuA//+K5oCADOVkUA==
Date: Mon, 21 Jan 2013 23:59:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1BD93@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
 <20130113224220.GE5041@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com>
 <20130114014239.GA29909@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998F69E12A43@DQHE02.ent.ti.com>
 <20130114025025.GA30179@opensource.wolfsonmicro.com>
In-Reply-To: <20130114025025.GA30179@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > OK, the consumer just cares about the regulator(s) which is(are)
> obtained.
> > However it doesn't show exact state of regulator in case that enable
> GPIOs are
> > shared.
> 
> It would do if my suggestion that we use a shared state for the GPIO
> were implemented!
> 
> > (6) CB tries to get the state of LDO3 before disabling it,
> > regulator_is_enabled() returns 1, but real state is 0.
> 
> > 	if(!regulator_is_enabled(rdev))
> > 		regulator_disable(rdev);
> 
> > 	Therefore CB never disables LDO3, use_count is always 1.
> 
> > This patch solves this unmatched situation.
> 
> This is just a buggy consumer - the consumer would also break if there
> were a single regulator shared by two consumers.  There's almost no
> case
> outside of bootstrapping where it makes sense to check if the regulator
> is enabled for anything other than diagnostics.
> 
> > Regulator APIs may show unmatched value, but it can be handled in
> each consumer
> > driver *separately*.
> > Therefore, we should not update 'ena_gpio_state' of other regulators.
> > This patch should be ignored.
> > Is that correct?
> 
> No, we need to reference count over all the regualtors sharing the
> enable line.  Otherwise we won't pay attention to references held by
> anything other than the regulator currently being enabled or disabled.

Updated patch-set was sent recently.

  [PATCH v2 1/4] regulator-core: support shared enable GPIO concept
  https://lkml.org/lkml/2013/1/14/564

  [PATCH v2 2/4] regulator-core: manage enable GPIO list
  https://lkml.org/lkml/2013/1/14/565

  [PATCH v2 3/4] regulator-core: free requested GPIOs and manage the enable list
  https://lkml.org/lkml/2013/1/14/567

  [PATCH v2 4/4] lp8788-ldo: use ena_pin of regulator-core for external control
  https://lkml.org/lkml/2013/1/14/566

I'd like to get some feedback from you.
Thank you.

Best Regards,
Milo
