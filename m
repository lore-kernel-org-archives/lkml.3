Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaAWJGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:06:32 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:32999 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAWJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:06:26 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 Jan 2014 14:36:05 +0530
Message-ID: <CA+V-a8t5PWv95mr3VCjRamC4gJFLJbh=K+ZA81uEeMfGh7k-1A@mail.gmail.com>
Subject: 
To: Mark Brown <broonie@linaro.org>, broonie@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I see a issue with one of the davinci boards, where regulator_get() fails
from this patch "regulator: core: Provide a dummy regulator with full
constraints".
as I see regulator_get() supports dummy regulators by default.

So currently I am booting it traditional way (NON DT way) and
regulator_dev_lookup()
fails (return NULL)  and for this check it fails.

+    if (ret && ret != -ENODEV) {
         regulator = ERR_PTR(ret);
         goto out;
     }
In the NON-DT case the 'ret' is never updated in regulator_dev_lookup().

I tried adding regulator_has_full_constraints(); call in .init_machine
but results
the same. Any pointer would be helpfull.

Thanks,
--Prabhakar Lad
