Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaGULj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:39:56 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35932 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaGULjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:39:54 -0400
Date: Mon, 21 Jul 2014 12:39:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Checkpatch query
Message-ID: <20140721113948.GX30888@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, Joe,

When running checkpatch on drivers/mfd/tps80031.c I recieve the
following warning:

> WARNING: Possible switch case/default not preceeded by break or
>          fallthrough comment
> #337: FILE: drivers/mfd/tps80031.c:337:
> +       case TPS80031_BACKUP_REG:
> 
> total: 0 errors, 1 warnings, 573 lines checked

... but we use switch statement fall through all the time when
identifying different types of registers used with Regmap.  Placing a
fall-through comment between them all sounds very messy to me.

Also, the warning only fires on 'case's which do not use '...'
notation, which seems a little odd.

Anyway, I'm not sure placing a 'fall through' comment makes the code
any cleaner or reduces possible failure rate in any way.  Is there any
chance that this check can be removed?

> static bool rd_wr_reg_id0(struct device *dev, unsigned int reg)
> {
> 	switch (reg) {
> 	case TPS80031_SMPS1_CFG_FORCE ... TPS80031_SMPS2_CFG_VOLTAGE:
> 		return true;
> 	default:
> 		return false;
> 	}
> }
> 
> static bool rd_wr_reg_id1(struct device *dev, unsigned int reg)
> {
> 	switch (reg) {
> 	case TPS80031_SECONDS_REG ... TPS80031_RTC_RESET_STATUS_REG:
> 	case TPS80031_VALIDITY0 ... TPS80031_VALIDITY7:
> 	case TPS80031_PHOENIX_START_CONDITION ... TPS80031_KEY_PRESS_DUR_CFG:
> 	case TPS80031_SMPS4_CFG_TRANS ... TPS80031_SMPS3_CFG_VOLTAGE:
> 	case TPS80031_BROADCAST_ADDR_ALL ... TPS80031_BROADCAST_ADDR_CLK_RST:
> 	case TPS80031_VANA_CFG_TRANS ... TPS80031_LDO7_CFG_VOLTAGE:
> 	case TPS80031_REGEN1_CFG_TRANS ... TPS80031_TMP_CFG_STATE:
> 	case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:
> 	case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:
> 	case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:
> 	case TPS80031_BACKUP_REG:
> 		return true;
> 	default:
> 		return false;
> 	}
> }
> 
> static bool is_volatile_reg_id1(struct device *dev, unsigned int reg)
> {
> 	switch (reg) {
> 	case TPS80031_SMPS4_CFG_TRANS ... TPS80031_SMPS3_CFG_VOLTAGE:
> 	case TPS80031_VANA_CFG_TRANS ... TPS80031_LDO7_CFG_VOLTAGE:
> 	case TPS80031_REGEN1_CFG_TRANS ... TPS80031_TMP_CFG_STATE:
> 	case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:
> 	case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:
> 	case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:
> 		return true;
> 	default:
> 		return false;
> 	}
> }



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
