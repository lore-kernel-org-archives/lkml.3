Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaGHIyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:54:00 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:55256 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E46A4@EAPEX1MAIL1.st.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E46A4@EAPEX1MAIL1.st.com>
Date: Tue, 8 Jul 2014 14:23:56 +0530
X-Google-Sender-Auth: QNML4lhq8d3UIEK2SOIm3NPZgpM
Message-ID: <CAOh2x=nLawh_X0M2ESDvxKNhhVUjE9yKEvfin3WTkNs8Kv5eUg@mail.gmail.com>
Subject: Re: [GIT PULL] SPEAr1310 PCIe patches rebased on 3.16-rc3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        "'Kishon Vijay Abraham I' (kishon@ti.com)" <kishon@ti.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Nicholson <mark@nicholnet.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohit,

On Tue, Jul 8, 2014 at 12:36 PM, Mohit KUMAR DCG <Mohit.KUMAR@st.com> wrote:
> Hello Arnd,
>
> Pls find SPEAr1310 pcie patches to be merged through arm-soc tree.
> These patches are rebased on the top of 3-16-rc3.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git
> spear/pcie-support-v8

You actually sent this request before Arnd's reply :).

This is what he asked for:

"Please also include a description of the overall series and the
reasons why we decided
to merge it through arm-soc in the pull request email. Thanks!"

Also this is not how we send pull requests, please see this:
http://git-scm.com/docs/git-request-pull

Let me know if you need some help.

Also, build-bot reported a warning with your patches and I have
fixed it now:

>> WARNING: drivers/built-in.o(.data+0x334): Section mismatch in reference from the variable spear1310_miphy_driver to the function .init.text:spear1310_miphy_probe()

diff --git a/drivers/phy/phy-spear1310-miphy.c
b/drivers/phy/phy-spear1310-miphy.c
index 6136634..dc0b97a 100644
--- a/drivers/phy/phy-spear1310-miphy.c
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -205,7 +205,7 @@ static struct phy *spear1310_miphy_xlate(struct device *dev,
        return priv->phy;
 }

-static int __init spear1310_miphy_probe(struct platform_device *pdev)
+static int spear1310_miphy_probe(struct platform_device *pdev)
 {
        struct device *dev = &pdev->dev;
        struct spear1310_miphy_priv *priv;
diff --git a/drivers/phy/phy-spear1340-miphy.c
b/drivers/phy/phy-spear1340-miphy.c
index cbaf284..e06e944 100644
--- a/drivers/phy/phy-spear1340-miphy.c
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -235,7 +235,7 @@ static struct phy *spear1340_miphy_xlate(struct device *dev,
        return priv->phy;
 }

-static int __init spear1340_miphy_probe(struct platform_device *pdev)
+static int spear1340_miphy_probe(struct platform_device *pdev)
 {
        struct device *dev = &pdev->dev;
        struct spear1340_miphy_priv *priv;

Please let me know if I screwed up. Else send pull request from
this branch again.

--
viresh
