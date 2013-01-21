Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3AURlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:41:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3AURlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:41:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob@ti.com>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Date: Mon, 21 Jan 2013 17:41:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-16-git-send-email-arnd@arndb.de> <50FD7A5F.9020702@ti.com>
In-Reply-To: <50FD7A5F.9020702@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211741.11875.arnd@arndb.de>
X-Provags-ID: V02:K0:hh3CP1k2vx5uj32IFF65CZQ4ip23+zXuH8D3cn5GgRZ
 Ipvti0AIU3GLcjKxiFgMrrl1C2h9jCgsEGyfjBCkt+kApy82Be
 Xhod4Bycu+HZPDPwBo1+H+mJ8qZT7FuKRKX65P2DCbcBJbTNOb
 BsGOprAcO/HIQPxdZFYruigmb6CRIVdJ1GfheT1tFTe2O/kQ3Y
 Diuq1glWq/A0yBOFr7lqcHD1RDPg4yDz/iFkJrG2vJcyjZ92t/
 n1ne/WFWTjcI2vqkyY1TByGwm6ixc/w8dpgdDeGU026cybKCX4
 JgOxLqD+jzsUJtX+yYhtnqgzXJvnIjyKzZ/RsagEraHVKOPHDZ
 m7zZAa+CGVsuCE8gFLAU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Rob Clark wrote:
> Are you sure OMAP2_DSS requires ARCH_OMAP2PLUS?  I don't see this, and 
> it at least used to not depend on ARCH_OMAP2PLUS.  If it does now, I 
> think the correct fix would be to remove the dependency in OMAP2_DSS.  I 
> don't think removing ARCH_MULTIPLATFORM support in omapdrm is the 
> correct solution.

At least it says so in drivers/video/omap2/Kconfig, which contains

if ARCH_OMAP2PLUS
source drivers/video/omap2/dss/Kconfig
endif

We can probably change this, but until we do, we should not select
OMAP2_DSS from something that doesn't also depend on ARCH_OMAP2PLUS.
 
> > drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
> > drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
> > drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier is reported only once for each function it appears in
> > drivers/staging/omapdrm/omap_connector.c: In function 'omap_connector_dpms':
> > drivers/staging/omapdrm/omap_connector.c:116:8: error: 'OMAP_DSS_DISPLAY_SUSPENDED' undeclared (first use in this function)
> > drivers/staging/omapdrm/omap_connector.c:116:8: note: each undeclared identifier is reported only once for each function it appears in
> 
> 
> This was an unrelated build break which should be fixed in latest master 
> after 'staging: drm/omap: use omapdss low level API'

Ok, it seems the message is stale then, I created the patch some time ago, but
only today wrote rest of the explanation for the changeset text.

With all the other patches from my series applied, allyesconfig still gives me

drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared

because that symbol is only defined when OMAP2_DSS is enabled rather than
selected. Changing drivers/video/omap2/Kconfig to not depend on OMAP seems
to work as well, but that seems a little intrusive for v3.8, because it would
let a lot of people build that code that have no use for it.

	Arnd
