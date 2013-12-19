Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3LSLj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:39:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48584 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3LSLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:39:22 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-7c-52b2dae8a08c
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v12 4/4] ARM: dts: Exynos5420: Add device nodes for TMU
 blocks
Date: Thu, 19 Dec 2013 12:39:04 +0100
Message-id: <1504232.pi5nrQckF4@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1387433222-7893-1-git-send-email-ch.naveen@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
 <1387433222-7893-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xq7ovbm0KMug7KGHRcDXEYuOM9awW
	d58fZrR4eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOfB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6Mm9dXsRcs4q9YOe0X
	WwPjF+4uRk4OCQETiXlN/5kgbDGJC/fWs3UxcnEICSxllOhv/8cE4XQxSXxqeskIUsUmoCbx
	ueERG4gtAtR9/NUZdpAiZoGlTBLzly1iBkkIC4RIvF8yA6ibg4NFQFXiyY4qkDCvgKbEtK3z
	WEBsfgF1iXfbnoJtFhVwk3ixbws7iM0p4Crxb8V9ZpBWIYF6iT0TgiBaBSV+TL4H1sosIC+x
	b/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcx
	QmLlyw7GxcesDjEKcDAq8fAGPN8YJMSaWFZcmXuIUYKDWUmEd9L1TUFCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGLPTn37n/fwn9Giv/uLIv6cYzgf9rLpvfNI4f/udO2dqQpt3XXytt7hc2X5P
	0pFbtn4TL5Ukf2P68D/ybbTLk2X7jaXNT657Ps/+3aSZBs793xfouOutDN6+Tfj4bTebb56+
	GUy5k77rHeSPCTrQZKZVZrPnFGvCgmvRlx5ZeAkrdZ7mcpSe9FmJpTgj0VCLuag4EQCYYhHg
	cwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Thursday 19 of December 2013 11:37:02 Naveen Krishna Chatradhi wrote:
> Exynos5420 SoC has per core thermal management unit.
> 5 TMU channels 4 for CPUs and 5th for GPU.
> 
> This patch adds the device tree nodes to the DT device list.
> 
> Nodes carry the misplaced second base address and the second
> clock to access the misplaced base address.
[snip]
>  		samsung,power-domain = <&gsc_pd>;
>  	};
> +
> +	tmu_cpu0:tmu@10060000 {

CodingStyle: Missing space after colon.
+ all the nodes below.

Since it's just a minor fixup, I think you could just reply to this
thread with corrected version of this single patch instead of
respinning the whole series.

Best regards,
Tomasz

> +		compatible = "samsung,exynos5420-tmu";
> +		reg = <0x10060000 0x100>;
> +		interrupts = <0 65 0>;
> +		clocks = <&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	tmu_cpu1:tmu@10064000 {
> +		compatible = "samsung,exynos5420-tmu";
> +		reg = <0x10064000 0x100>;
> +		interrupts = <0 183 0>;
> +		clocks = <&clock 318>;
> +		clock-names = "tmu_apbif";
> +	};
> +
> +	tmu_cpu2:tmu@10068000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
> +		interrupts = <0 184 0>;
> +		clocks = <&clock 318>, <&clock 318>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
> +
> +	tmu_cpu3:tmu@1006c000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
> +		interrupts = <0 185 0>;
> +		clocks = <&clock 318>, <&clock 319>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
> +
> +	tmu_gpu:tmu@100a0000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
> +		interrupts = <0 215 0>;
> +		clocks = <&clock 319>, <&clock 318>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
> +	};
>  };
> 

