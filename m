Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab3GPTPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:15:39 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:50480 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933253Ab3GPTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:15:38 -0400
Message-ID: <51E599A2.3040306@overkiz.com>
Date: Tue, 16 Jul 2013 21:06:10 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3 6/7] USB: ohci-at91: add usb_clk for transition to
 common clk framework
References: <Pine.LNX.4.44L0.1307161441350.1032-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307161441350.1032-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11063373960700655718
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/2013 20:47, Alan Stern wrote:
> On Tue, 16 Jul 2013, boris brezillon wrote:
>
>>>> +	uclk = clk_get(&pdev->dev, "usb_clk");
>>>> +	if (IS_ERR(uclk)) {
>>>> +		uclk = NULL;
>>>> +		dev_warn(&pdev->dev, "failed to get usb_clk\n");
>>>> +	}
>>> Is this really what you want for backward compatibility?
>> Here are some proposition to remove the warning message:
>>
>> 1) replace it with a dev_info and change the message:
>>       dev_info(&pdev->dev, "failed to get usb_clk (most likely using old
>> at91 clk implementation)\n");
>> 2) drop the log and silently ignore the missing clk (I'm not a big fan
>> of this solution
>>       as it may lead to some errors if we're using new clk implem and the
>> clock is really missing)
>> 3) rework the current clk_set_rate function to accept clk_set_rate on
>> usb clk and add clk_lookup entries
>>       for the usb clk (I'm not a big fan of this solution neither as this
>> modifications will only be used for a short time
>>       until the transition to common clk framework is completed).
> Another possibility is to combine this change with the clock
> implementation update, and do them in a single patch.  Then backward
> compatibility would not be an issue.
Yes, that was one of the question I asked in the cover-letter.

I think I'll move these patches in the "move to common clk" series.

Thanks
> Alan Stern
>

