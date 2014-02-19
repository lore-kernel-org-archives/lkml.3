Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaBSRFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:05:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38343 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaBSRFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:05:46 -0500
Message-ID: <5304E41F.4080205@ti.com>
Date: Wed, 19 Feb 2014 19:04:31 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@kernel.crashing.org>, <devicetree@vger.kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <nsekhar@ti.com>,
        "[initial author] Murali Karicheri" <m-karicheri2@ti.com>
Subject: Re: [PATCH v4 1/2] memory: ti-aemif: introduce AEMIF driver
References: <1391629574-18955-1-git-send-email-ivan.khoronzhuk@ti.com> <1391629574-18955-2-git-send-email-ivan.khoronzhuk@ti.com> <20140218203049.GA18647@kroah.com> <53048822.2080307@ti.com> <20140219143403.GA31063@kroah.com>
In-Reply-To: <20140219143403.GA31063@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/19/2014 04:34 PM, Greg KH wrote:
> On Wed, Feb 19, 2014 at 12:32:02PM +0200, Ivan Khoronzhuk wrote:
>>>> +	aemif->clk = devm_clk_get(dev, NULL);
>>>> +	if (IS_ERR(aemif->clk)) {
>>>> +		dev_err(dev, "cannot get clock 'aemif'\n");
>>>> +		return PTR_ERR(aemif->clk);
>>> No freeing memory?
>> There is no need to free memory explicitly.
>> devm_kzalloc is used instead of kzalloc.
> Yes, but where does the device on the error path get removed?

Why these functions are needed in that case...

As I see, memory allocated with these functions
are automatically freed on driver detach.

Additionally I've checked if resources are released after
AEMIF driver probe error.
And they're released completely in case of probe error.

:-\

-- 
Regards,
Ivan Khoronzhuk

