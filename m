Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3C0AP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:15:28 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:55022 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3C0AP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:15:27 -0400
Message-ID: <1364343321.13123.3.camel@phoenix>
Subject: regulator: ab8500: ambiguous meaning of delay setting in struct
 ab8500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 08:15:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The comment of struct ab8500_regulator_info says the delay means
"startup/set voltage delay in us".
I'm confused by the meaning, does it mean enable_time or set_voltage_time_sel
time or both?

 * @enable_time: Time taken for the regulator voltage output voltage to
 *               stabilise after being enabled, in microseconds.

 * @set_voltage_time_sel: Time taken for the regulator voltage output voltage
 *               to stabilise after being set to a new value, in microseconds.
 *               The function provides the from and to voltage selector, the
 *               function should return the worst case.

Current code only has delay setting for AB8500_LDO_TVOUT, it looks like it
means enable_time rather than the delay for set_voltage_time_sel.
(well, AB8500_LDO_TVOUT is fixed voltage, it does not implement set_voltage_time_sel)

ab8500_regulator_set_voltage_time_sel() returns info->delay, but all it's users
(AB8500_LDO_AUX1, AB8500_LDO_AUX2, AB8500_LDO_AUX3, AB8500_LDO_INTCORE)
do not has delay setting. ( So now ab8500_regulator_set_voltage_time_sel returns 0. )

Axel

