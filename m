Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab3BHETk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:19:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690Ab3BHETj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:19:39 -0500
Message-ID: <51147CCF.7050100@ti.com>
Date: Fri, 8 Feb 2013 09:49:27 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "wim@iguana.be" <wim@iguana.be>
Subject: Re: [PATCH] watchdog: davinci_wdt: update to devm_* API
References: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com> <5113E978.2060201@ti.com> <F3DBB1B3EF102E4994C89758CFCA32412C59CA@DBDE01.ent.ti.com>
In-Reply-To: <F3DBB1B3EF102E4994C89758CFCA32412C59CA@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2013 8:05 AM, Kumar, Anil wrote:
> On Thu, Feb 07, 2013 at 23:20:48, Nori, Sekhar wrote:
>> On 2/7/2013 9:02 AM, Kumar, Anil wrote:

>>> Update the code to use devm_* API so that driver
>>> core will manage resources.

>>> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>

>>> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c

>>> @@ -201,10 +200,10 @@ static struct miscdevice davinci_wdt_miscdev = {
>>>  
>>>  static int davinci_wdt_probe(struct platform_device *pdev)
>>>  {
>>> -	int ret = 0, size;
>>> -	struct device *dev = &pdev->dev;
>>
>> Its not clear why you had to drop use of this variable?
> 
> Actually, I have not found any particular need to take pointer
> into dev and then use in the code. Rather we can directly use. 

No, it is good enough as-is. It will help rid your patch of unnecessary
changes and its not really convenient to to keep reading &pdev->dev all
the time.

Thanks,
Sekhar
