Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3FJPWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:22:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3FJPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:22:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Mon, 10 Jun 2013 17:22:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com> <201306071943.18407.arnd@arndb.de> <000001ce65b5$e45477f0$acfd67d0$@samsung.com>
In-Reply-To: <000001ce65b5$e45477f0$acfd67d0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101722.10146.arnd@arndb.de>
X-Provags-ID: V02:K0:cSh1K6nYQd3A208WxT86+Mg5mqd4NiFjsM5MNXz++WN
 LpSj7SC+kffJRCto6UMf+3d0Puh0bZ9jSfHmbaGTduhjdOoGjB
 FiovvJyQgxDSgC8LS37YDBEZzE1KF2mlVde+3vzilUj5vwVgyG
 MEktcSVwaLCIfuiVNnePZYVIE9JFiAyaGO4e28AVugUZ1UfsLg
 4QrCgTpH7wLNRZK6Lyq5RpeAY+wI0x8WG+XCueXj5VuiBSY8L3
 Mln5Gjb45cN/tDDC7FluKjIooYnujiTGR+RsmpKWSx32gcuKB5
 bBSmEVOZPyyZ3fVfDVdEzVq6+lr8u3b1RN1uMw7oIy/g9/nZ54
 xaFwcOd0vCCAFW+B37xY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013, Jingoo Han wrote:
> On Saturday, June 08, 2013 2:43 AM, Arnd Bergmann wrote:
> For multiple domains, how can I fix the DT properties?

Domains are a Linux concept, you have to pick a new domain number for each
struct hw_pci you register.
 
> Current DT properties are as below:
> 
> +	pcie0@40000000 {
> +		compatible = "samsung,exynos5440-pcie";
> +		reg = <0x40000000 0x4000
> +			0x290000 0x1000
> +			0x270000 0x1000
> +			0x271000 0x40>;
> +		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> +		#address-cells = <3>;
> +		#size-cells = <2>;
> +		device_type = "pci";
> +		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> +			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> +			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> +	};

An unrelated comment: your first "reg" field seems to overlap with part
of your configuration space. Is that intentional?

Also, shouldn't your memory space end on a 256MB boundary, rather than
extend up to 0x50203fff?

	Arnd
