Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaKGMKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:10:25 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52487 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKGMKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:10:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] ARM: STi: DT: STih407: Abstract common dt nodes into shared files.
Date: Fri, 07 Nov 2014 13:10:05 +0100
Message-ID: <3301013.ouyFbjlpZY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415361475-6218-12-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org> <1415361475-6218-12-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kfVcbYZEuPCPKdNunCNs1kOJmr51GoM1cnVjvmF7YyB
 CGX7q3HWQimH3eIxyBqwofyLJMJmMF67MwCvRqw+aCXLVeV1hM
 shbQT/HKe4k/5GsdEpau8RgiE+pKhbKCWEAAodWh+fU8m0UeYT
 QK2CA/W7K8ydHSKiPbUL+7bx1uAQPpjCG2bgrD28JBXolKHhmH
 4VhNbh/rJYbGabRyCneosaUokYl0Lb1c+2rGrc4sbBAiScjIZl
 2/ZGFSKupk5JG7CKxmtmKb/DDLkihi5t35Kof2tH9ysiBsSiLF
 S5Iie2+QXdiRmjrwNj8Nf6fm+JvK/exXtS4YoC0cptilU53bRF
 207onFePa1VTzorH8Qo8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 11:57:53 Peter Griffin wrote:
> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> new file mode 100644
> index 0000000..862bb2f
> --- /dev/null
> +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> @@ -0,0 +1,73 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/ {
> +       chosen {
> +               bootargs = "console=ttyAS0,115200";
> +               linux,stdout-path = &sbc_serial0;
> +       };
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x40000000 0x80000000>;
> +       };
> +
> +       aliases {
> +               ttyAS0 = &sbc_serial0;
> +       };
> +
> 

Please leave these in the per-board file, each board would have different
values, so it makes no sense to have them in the shared file.

	Arnd
