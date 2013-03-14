Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3CNLj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:39:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56266 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab3CNLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:39:26 -0400
Message-ID: <5141B6D8.2050308@ti.com>
Date: Thu, 14 Mar 2013 17:09:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <thierry.reding@avionic-design.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/3] pwm: davinci: Add Kconfig support for ECAP & EHRPWM
 devices
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com> <1363257158-11615-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1363257158-11615-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/2013 4:02 PM, Philip Avinash wrote:
> Add EHRPWM and ECAP support build support for DAVINCI_DA850 platforms.
> 
> Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
> remove the select option for CONFIG_PWM_TIPWMSS.
> 
> Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
> pwm-tipwmss.h to fix the below compiler error upon removal of
> CONFIG_PWM_TIPWMSS for Davinci platforms.
> 
> 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_probe':
> 	drivers/pwm/pwm-tiecap.c:263:4: error: 'PWMSS_ECAPCLK_EN' undeclared
> 	(first use in this function)
> 	drivers/pwm/pwm-tiecap.c:263:4: note: each undeclared identifier
> 	is reported only once for each function it appears in
> 	drivers/pwm/pwm-tiecap.c:264:17: error: 'PWMSS_ECAPCLK_EN_ACK'
> 	undeclared (first use in this function)
> 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_remove':
> 	drivers/pwm/pwm-tiecap.c:291:49: error: 'PWMSS_ECAPCLK_STOP_REQ'
> 	undeclared (first use in this function)
> 	make[2]: *** [drivers/pwm/pwm-tiecap.o] Error 1
> 	make[1]: *** [drivers/pwm] Error 2
> 	make: *** [drivers] Error 2
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

>  config  PWM_TIECAP
>  	tristate "ECAP PWM support"
> -	depends on SOC_AM33XX
> -	select PWM_TIPWMSS
> +	depends on SOC_AM33XX || ARCH_DAVINCI_DA850

Having such narrow dependencies is wrong. The same device is present on
DaVinci DA830 too. A depends on should not be required at all since the
driver should build on all architectures. But I have seen resistance to
doing that since users don't like to see configuration options totally
irrelevant for the architecture they are building for. So may be take a
middle path and do 'depends on ARCH_ARM'?

Thanks,
Sekhar
