Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaENIxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:53:10 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57892 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbaENIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:53:07 -0400
Message-ID: <53732EAB.1050709@st.com>
Date: Wed, 14 May 2014 10:51:55 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        olof Johansson <olof@lixom.net>
Cc: <devicetree@vger.kernel.org>, <kernel@stlinux.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        <linux-input@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [STLinux Kernel] [PATCH v4 2/7] driver: reset: sti: add keyscan
 for stih415
References: <1397228856-9218-1-git-send-email-gabriel.fernandez@linaro.org> <1397228856-9218-3-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1397228856-9218-3-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-14_02:2014-05-13,2014-05-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

	I am preparing the arm_soc pull request for STi platforms.

	In this series, there are DT patches depending on this reset patch 
(same for patch 3).

	Can I queue theses two reset patches in my pull request for arm_soc to 
avoid compilation breakage?

Best regards,
Maxime

On 04/11/2014 05:07 PM, Gabriel FERNANDEZ wrote:
> Add keyscan reset on stih415 reset controller.
>
> Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>   drivers/reset/sti/reset-stih415.c                     | 1 +
>   include/dt-bindings/reset-controller/stih415-resets.h | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/drivers/reset/sti/reset-stih415.c b/drivers/reset/sti/reset-stih415.c
> index e6f6c41..c93fd26 100644
> --- a/drivers/reset/sti/reset-stih415.c
> +++ b/drivers/reset/sti/reset-stih415.c
> @@ -73,6 +73,7 @@ static const struct syscfg_reset_channel_data stih415_softresets[] = {
>   	[STIH415_USB0_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 9),
>   	[STIH415_USB1_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 10),
>   	[STIH415_USB2_SOFTRESET] = STIH415_SRST_REAR(SYSCFG_376, 11),
> +	[STIH415_KEYSCAN_SOFTRESET] = STIH415_SRST_LPM(LPM_SYSCFG_1, 8),
>   };
>
>   static struct syscfg_reset_controller_data stih415_powerdown_controller = {
> diff --git a/include/dt-bindings/reset-controller/stih415-resets.h b/include/dt-bindings/reset-controller/stih415-resets.h
> index c2f8a66..c2329fe 100644
> --- a/include/dt-bindings/reset-controller/stih415-resets.h
> +++ b/include/dt-bindings/reset-controller/stih415-resets.h
> @@ -22,5 +22,6 @@
>   #define STIH415_USB0_SOFTRESET		3
>   #define STIH415_USB1_SOFTRESET		4
>   #define STIH415_USB2_SOFTRESET		5
> +#define STIH415_KEYSCAN_SOFTRESET	6
>
>   #endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH415 */
>
