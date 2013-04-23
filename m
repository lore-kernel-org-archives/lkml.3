Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3DWSzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:55:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3DWSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:55:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 12/21] mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE
Date: Tue, 23 Apr 2013 20:55:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-13-git-send-email-arnd@arndb.de> <87bo95tctk.fsf@octavius.laptop.org>
In-Reply-To: <87bo95tctk.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232055.32715.arnd@arndb.de>
X-Provags-ID: V02:K0:RsSHkUlttN70n3kqd6KDsyEOdGok+SYYSmO1NlfVTUr
 bNJjy9l6LWDvEcRAkiOBN8KEwvkIyMDCNfjgkD47uoq7FTIe/l
 2E12IOh5YRu76Ow2viADVh6zmHFHBlNVqOPkN7Yyp44jJj0r/p
 8SVRca5+wqNpydB/QsEa+yGJ1HrdXneYz4mw/DcshK0PxBlzmM
 0w+fv89OEcV1jCqszfXHW2iw9K0bLNDPawOAGO5U0xiz0S+die
 g0uMwbISXyDcDupt0Vvi7qzUp4gTVdjNzkaB8H8DRDE/WaD52M
 ajOJRTSbhGUratKaL5faNubsHRSb1xf0UPMB33IkfaAJaZ3J2k
 bpE6QG9S0yMdGOar4Ng4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol referenced in MODULE_DEVICE_TABLE must match the actual
table, otherwise we get a build error like

sdhci-tegra.c:206:34: error: '__mod_of_device_table' aliased to undefined symbol 'sdhci_dt_ids'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Chris Ball <cjb@laptop.org>
---
On Tuesday 23 April 2013, Chris Ball wrote:

> I was going to take this, but it doesn't apply to mmc-next or
> linux-next, because the #endif in your first line of context isn't
> present in those trees -- which tree is this based on?

I based it on 3.9-rc8.

> Sounds like it might make more sense for you to take this; if so:
> Acked-by: Chris Ball <cjb@laptop.org>

This is the rebased version on linux-next. I think it's better if you
take it, otherwise we just create a merge conflict for Linus.

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 45048d1..e0dba74 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -203,7 +203,7 @@ static const struct of_device_id sdhci_tegra_dt_match[] = {
 	{ .compatible = "nvidia,tegra20-sdhci", .data = &soc_data_tegra20 },
 	{}
 };
-MODULE_DEVICE_TABLE(of, sdhci_dt_ids);
+MODULE_DEVICE_TABLE(of, sdhci_tegra_dt_match);
 
 static void sdhci_tegra_parse_dt(struct device *dev)
 {
