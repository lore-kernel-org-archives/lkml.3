Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3BPIp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:45:59 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56674 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab3BPIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:45:58 -0500
Message-ID: <511F47AC.102@metafoo.de>
Date: Sat, 16 Feb 2013 09:47:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] clk: Add axi-clkgen driver
References: <1358949892-19986-1-git-send-email-lars@metafoo.de> <20130216025234.11471.8029@quantum>
In-Reply-To: <20130216025234.11471.8029@quantum>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 03:52 AM, Mike Turquette wrote:
> Quoting Lars-Peter Clausen (2013-01-23 06:04:52)
>> +static const struct of_device_id axi_clkgen_ids[] = {
>> +       { .compatible = "adi,axi-clkgen-1.00.a" },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, axi_clkgen_ids);
> 
> This method is deprecated.  Can you convert over to the newer
> of_clk_init method?  See:
> 
> http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=commit;h=f2f6c2556dcc432e50003bc8fa4d62d95906f149

Hi,

I'm not sure this makes sense here. That would mean completely bypassing the
device driver model. And since this device is on a kind of external bus it may
or may not be present at the time of_clk_init() runs.

- Lars
