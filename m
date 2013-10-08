Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3JHGJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:09:22 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2080 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3JHGJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:09:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Oct 2013 23:05:14 -0700
Message-ID: <5253A17E.10503@nvidia.com>
Date: Tue, 8 Oct 2013 14:09:02 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: About [PATCH 1/2] regulator: core: Provide a dummy regulator with
 full constraints
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark
In the latest regulator framework, it default to provide dummy
regulators with full constraints by your patch "regulator: core: Provide
a dummy regulator with full constraints".
I tried to use regulator_get() on lm90.c. If not set vcc-supply property
in the dts file to assume the regulator is physically present and
enabled, but it still can't get dummy regulator, just return -ENODEV.
I traced it, the regulator_dev_lookup() will return -ENODEV, and at that
time the has_full_constraints is still false, didn't be initialized in
regulator_init_complete() yet, so it will not return dummy regulator,
and will not return -EPROBE_DEFER either. This will cause the
lm90_probe() failed.

Could you take a look ?

Thanks.
Wei.
