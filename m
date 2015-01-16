Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbbAPFuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:50:19 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:55139 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbbAPFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:50:17 -0500
X-Listener-Flag: 11101
Subject: Re: [RFC 01/11] i2c: add quirk structure to describe adapter flaws
From: Eddie Huang <eddie.huang@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
	 <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jan 2015 13:50:08 +0800
Message-ID: <1421387408.9323.10.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Fri, 2015-01-09 at 18:21 +0100, Wolfram Sang wrote:
>  
> + */
> +struct i2c_adapter_quirks {
> +	u64 flags;
> +	int max_num_msgs;
> +	u16 max_write_len;
> +	u16 max_read_len;
> +	u16 max_comb_write_len;
> +	u16 max_comb_read_len;
> +};
> +
> +#define I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST	BIT(0)
> +#define I2C_ADAPTER_QUIRK_COMB_READ_SECOND	BIT(1)
> +#define I2C_ADAPTER_QUIRK_COMB_WRITE_THEN_READ	(I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST | \
> +						I2C_ADAPTER_QUIRK_COMB_READ_SECOND)
> +
>  /*
>   * i2c_adapter is the structure used to identify a physical i2c bus along
>   * with the access algorithms necessary to access it.
> @@ -472,6 +506,7 @@ struct i2c_adapter {
>  	struct list_head userspace_clients;
>  
>  	struct i2c_bus_recovery_info *bus_recovery_info;
> +	struct i2c_adapter_quirks *quirks;
>  };
>  #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
>  

I suggest to add const.
	const struct i2c_adapter_quirks *quirks;

also, in i2c-core.c, should modify:
	const struct i2c_adapter_quirks *q = adap->quirks;



