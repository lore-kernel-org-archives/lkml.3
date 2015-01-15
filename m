Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAOK7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:59:51 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41387 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:59:47 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Two variants of fixing Tegra20 suspend bug
Date: Thu, 15 Jan 2015 13:58:56 +0300
Message-Id: <1421319545-23920-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is third attempt to fix Tegra20 suspend bug. First was to use other
PMC scratch register for tegra_resume() address store and second to use syscore
ops for PMC driver.

Thierry Reding proposed other solution: to use IRAM instead of PMC scratch
register. I prepared two implementation variants:

        1) Store CPU "resettable" status in IRAM
        2) Store tegra_resume() address in IRAM

Both variants use reset handler IRAM area for placing tegra_resume() address,
since it is reserved and guarantees avoidance of any further possible memory
conflicts.

As for me, second variant is cleaner. It removes suspend PM from PMC driver,
which can be re-added later if needed.
