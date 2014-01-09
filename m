Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaAIKFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:05:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAIKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:05:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v3 2/3] ata: ahci_platform: Manage SATA PHY
Date: Thu, 9 Jan 2014 11:05:20 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>, tj@kernel.org,
        sergei.shtylyov@cogentembedded.com, b.zolnierkie@samsung.com,
        hdegoede@redhat.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Balaji T K <balajitk@ti.com>
References: <1389174428-31414-1-git-send-email-rogerq@ti.com> <5878159.3LjUeZKdYB@wuerfel> <52CE40FA.5070605@ti.com>
In-Reply-To: <52CE40FA.5070605@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401091105.20727.arnd@arndb.de>
X-Provags-ID: V02:K0:1eZYu3J0EJ/t/O94cDoZYf1Wd724tQ6khLCUsYXu3B6
 y+K91xGolfCET7aWmEweguUIHoZeSSP3Z4FtHWktkU+TYsvier
 FxbOPIZOneJOz0APRWQPnsH+/BXFj0VcTQLpDcAOVzhZxnkzx4
 HErvLyzhmlg36wE8+4U9OHxvjsVt2SXGgowevd+gCGzsuFcNqm
 M2xPe2UF8/XJI7wjn9q74cPSjfMhZ2v2blsPv/ee9vYGTX61Id
 yN/zY9z5XpDAajTwcyuSm2E+oY9ZRM2yWs7XKG07+Ga4/VqHZG
 bBC88buOVBc0NLgC74fqdb/xouepiDppX7nKvoYEj3W0EGq0p/
 UEl5nB8UxIn76xijh/ZI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014, Roger Quadros wrote:
> >> if (!IS_ERR(hpriv->phy)) {
> >>         rc = phy_init(hpriv->phy);
> >>         if (rc)
> >>                 goto disable_unprepare_clk;
> >>
> >>         rc = phy_power_on(hpriv->phy);
> >>         if (rc) {
> >>                 phy_exit(hpriv->phy);
> >>                 goto disable_unprepare_clk;
> >>         }
> >> }
> > 
> > As I said, I'd prefer to set hpriv->phy to NULL in case of -ENODEV,
> > but functionally it seems right (with the fixup from your other mail).
> > 
> 
> Why do you prefer setting hpriv->phy to NULL instead of using IS_ERR() check
> before hpriv->phy is used?
> The latter seems to be the norm at least among clock framework users.

Two reasons:

1. It feels more natural to read "if (clk)" in driver code as a check for
   "a clock exists" than "if (!IS_ERR(clk))".
2. It clarifies that this code path is only there to check for the
   clk-not-present case, not for other errors.

Obviously the first check after clk_get needs to be IS_ERR() because that
is the documented interface, but then you should decide on the action
based on the specific error.

	Arnd
