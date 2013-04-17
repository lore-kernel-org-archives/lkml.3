Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712Ab3DQDYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 23:24:51 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:48011 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965667Ab3DQDYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 23:24:50 -0400
Message-ID: <1366169084.10398.4.camel@phoenix>
Subject: regulator: tps80031: question about LDO2 TRACK_MODE_ENABLE of
 TPS80031 or TPS80032-ES1.0
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 11:24:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Laxman,

Currently we have below code in tps80031_ldo_set_voltage_sel():

        /* Check for valid setting for TPS80031 or TPS80032-ES1.0 */
        if ((ri->rinfo->desc.id == TPS80031_REGULATOR_LDO2) &&
                        (ri->device_flags & TRACK_MODE_ENABLE)) {
                unsigned nvsel = (sel) & 0x1F;
                if (((tps80031_get_chip_info(parent) == TPS80031) ||
                        ((tps80031_get_chip_info(parent) == TPS80032) &&
                        (tps80031_get_pmu_version(parent) == 0x0))) &&
                        ((nvsel == 0x0) || (nvsel >= 0x19 && nvsel <= 0x1F))) {
                                dev_err(ri->dev,
                                        "Invalid sel %d in track mode LDO2\n",
                                        nvsel);
                                return -EINVAL;
                }
        }

However, list_voltage() still show these invalid selectors have supported voltage.
Besides, having the code "nvsel = (sel) & 0x1F" looks a bit odd, because currently
n_voltages is set to 57 when TRACK_MODE_ENABLE is set.

I'm wondering if below comment is still true for LDO2 TRACK_MODE_ENABLE of
"TPS80031/TPS80032-ES1.0"?

/* TRACK mode the ldo2 varies from 600mV to 1300mV */

What is the register value && voltage mapping for LDO2 TRACK_MODE_ENABLE of
TPS80031 or TPS80032-ES1.0?

Regards,
Axel

