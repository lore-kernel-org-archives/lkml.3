Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3HCJNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 05:13:14 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43083 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3HCJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 05:13:13 -0400
Message-ID: <1375521188.3891.3.camel@phoenix>
Subject: regulator: s2mps11: Question about the code updating ramp_delay
 setting
From: Axel Lin <axel.lin@ingics.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 03 Aug 2013 17:13:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,
The code updating ramp_delay setting looks wrong to me.

Current code:
        return regmap_update_bits(rdev->regmap, ramp_reg,
                                  ramp_val << ramp_shift, 1 << ramp_shift);
I'd expect something like below:
        return regmap_update_bits(rdev->regmap, ramp_reg,
                                  ramp_mask << ramp_shift,
                                  ramp_val << ramp_shift);
I don't have the datasheet so I don't know the correct ramp_mask setting
here. Can you check if this needs fix?

Thanks,
Axel


