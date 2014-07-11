Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaGKJHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:07:04 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45289 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaGKJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <1404906074-31992-4-git-send-email-lee.jones@linaro.org>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
	<1404906074-31992-4-git-send-email-lee.jones@linaro.org>
Date: Fri, 11 Jul 2014 11:07:00 +0200
Message-ID: <CAG374jC1s3A6i+ivO51E-N-9QAa4Pcfh909xPZAtmZ_onUM_LQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon <kishon@ti.com>, "kernel@stlinux.com" <kernel@stlinux.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

One suggestion

On 9 July 2014 13:41, Lee Jones <lee.jones@linaro.org> wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/phy/Kconfig         |  10 +
>  drivers/phy/Makefile        |   1 +
>  drivers/phy/phy-miphy365x.c | 616 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 627 insertions(+)
>  create mode 100644 drivers/phy/phy-miphy365x.c
>

[...]

> diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
> new file mode 100644
> index 0000000..65ecd04
> --- /dev/null
> +++ b/drivers/phy/phy-miphy365x.c
> @@ -0,0 +1,616 @@

[...]

> +
> +struct miphy365x_phy {
> +       struct phy *phy;
> +       void __iomem *base;
> +       void __iomem *sata;
> +       void __iomem *pcie;
> +       u8 type;
> +       u8 port;


if we add:
     struct miphy365x_dev *phydev;

it's could simplified call of procedures below ?

for e.g.
static int miphy365x_set_path(struct miphy365x_phy *miphy_phy,
                             struct miphy365x_dev *miphy_dev)

into

static int miphy365x_set_path(struct miphy365x_phy *miphy_phy)
{
    struct miphy365x_dev *miphy_dev=miphy_phy->phydev;


[...]

Best regards
Gabriel
