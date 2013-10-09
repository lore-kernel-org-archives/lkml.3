Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3JIHXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:23:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48153 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3JIHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:23:12 -0400
Message-ID: <52550447.5070805@ti.com>
Date: Wed, 9 Oct 2013 12:52:47 +0530
From: Afzal Mohammed <afzal@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: wakeupgen: AM43x adaptation
References: <1378378535-2967-1-git-send-email-afzal@ti.com> <20131008212436.GR8313@atomide.com>
In-Reply-To: <20131008212436.GR8313@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wednesday 09 October 2013 02:54 AM, Tony Lindgren wrote:
> * Afzal Mohammed <afzal@ti.com> [130905 04:03]:

>> -#define MAX_NR_REG_BANKS	5
>> -#define MAX_IRQS		160
>> +/* maximum value correspond to that of AM43x */
>> +#define MAX_NR_REG_BANKS	7
>> +#define MAX_IRQS		224
>> +#define DEFAULT_NR_REG_BANKS	5
>> +#define DEFAULT_IRQS		160
>>  #define WKG_MASK_ALL		0x00000000
>>  #define WKG_UNMASK_ALL		0xffffffff
>>  #define CPU_ENA_OFFSET		0x400
> 
> How about define it like this to avoid updating things
> in multiple places for new SoCs:
> 
> #define AM43X_NR_REG_BANKS	7
> #define MAX_NR_REG_BANKS	AM43X_NR_REG_BANKS

Yes that is better

>>  	for (i = 0; i < irq_banks; i++) {
>>  		wakeupgen_writel(0, i, CPU0_ID);
>> -		wakeupgen_writel(0, i, CPU1_ID);
>> +		if (!am43x)
>> +			wakeupgen_writel(0, i, CPU1_ID);
>>  	}
> 
> Why not use soc_is_am43xx() directly here?

Ok, it has been changed in the new version.

Regards
Afzal
