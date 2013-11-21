Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3KUPje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:39:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40270 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3KUPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:39:33 -0500
Message-ID: <528E2917.1060707@ti.com>
Date: Thu, 21 Nov 2013 17:39:03 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH] clk: keystone: gate: don't use reserved bits
References: <1385047851-14407-1-git-send-email-ivan.khoronzhuk@ti.com> <448912EABC71F84BBCADFD3C67C4BE52965812@DBDE04.ent.ti.com>
In-Reply-To: <448912EABC71F84BBCADFD3C67C4BE52965812@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 05:35 PM, Shilimkar, Santosh wrote:
> Sorry for top posting. The user-guide is not upto date....
>
> State
> 4:0
> R
> Actual state
> Current Power Domain State.
> Only PSM states Off and On are “key states” that users should consider in normal run time situation. States with bit 4 = 1 are transitional states helpful for debug if PSM is stuck in those states.
>
> Regards,
> Santosh
>
> ________________________________________
> From: Khoronzhuk, Ivan
> Sent: Thursday, November 21, 2013 10:30 AM
> To: Shilimkar, Santosh
> Cc: Mike Turquette; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Strashko, Grygorii; Khoronzhuk, Ivan
> Subject: [PATCH] clk: keystone: gate: don't use reserved bits
>
> According to TRM http://www.ti.com/lit/ug/sprugv4b/sprugv4b.pdf
> the Power Domain Status Register (PDSTAT) has 0-1 bits for power
> domain status, but PDSTAT_STATE_MASK is defined with 0x1F. In that
> case we operate with reserved bits. So correct PDSTAT_STATE_MASK
> to be 0x03.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>   drivers/clk/keystone/gate.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
> index 1f333bc..995ae80 100644
> --- a/drivers/clk/keystone/gate.c
> +++ b/drivers/clk/keystone/gate.c
> @@ -35,7 +35,7 @@
>
>   #define MDSTAT_STATE_MASK      0x3f
>   #define MDSTAT_MCKOUT          BIT(12)
> -#define PDSTAT_STATE_MASK      0x1f
> +#define PDSTAT_STATE_MASK      0x03
>   #define MDCTL_FORCE            BIT(31)
>   #define MDCTL_LRESET           BIT(8)
>   #define PDCTL_NEXT             BIT(0)
> --
> 1.7.9.5
>

Ok

-- 
Regards,
Ivan Khoronzhuk
