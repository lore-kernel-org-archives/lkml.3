Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab3JOUjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:39:14 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:50779 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab3JOUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:10 -0400
Message-ID: <525DA7AE.8030102@cogentembedded.com>
Date: Wed, 16 Oct 2013 00:38:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 4/5] net: macb: Use devm_request_irq()
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-5-git-send-email-soren.brinkmann@xilinx.com> <525D95A4.3020706@cogentembedded.com> <ffb65abe-36e2-45c3-9d40-02050545184d@TX2EHSMHS038.ehs.local>
In-Reply-To: <ffb65abe-36e2-45c3-9d40-02050545184d@TX2EHSMHS038.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 12:20 AM, Sören Brinkmann wrote:

>>> Use the device managed interface to request the IRQ, simplifying error
>>> paths.

>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>>   drivers/net/ethernet/cadence/macb.c | 8 +++-----
>>>   1 file changed, 3 insertions(+), 5 deletions(-)

>>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>>> index 436aecc31732..603844b1d483 100644
>>> --- a/drivers/net/ethernet/cadence/macb.c
>>> +++ b/drivers/net/ethernet/cadence/macb.c
>>> @@ -1825,7 +1825,8 @@ static int __init macb_probe(struct platform_device *pdev)
>>>   	}
>>>
>>>   	dev->irq = platform_get_irq(pdev, 0);
>>> -	err = request_irq(dev->irq, macb_interrupt, 0, dev->name, dev);
>>> +	err = devm_request_irq(&pdev->dev, dev->irq, macb_interrupt, 0,
>>> +			dev->name, dev);

>>     You should start the continuation line right under &.

> Actually this one is a good example why I don't do such alignment: You
> do a simple search & replace - in this case request_irq ->
> devm_request_irq - and all alignment is gone.

    I didn't understand why this is a good example. In this case you broke the 
line yourself and did it incorrectly, not following the networking coding 
style which assumes Emacs-style alignment for broken lines.

> 	Sören

WBR, Sergei

