Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3HAPO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:14:57 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:57795 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755605Ab3HAPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:14:55 -0400
Message-ID: <51FA7B6A.80106@overkiz.com>
Date: Thu, 01 Aug 2013 17:14:50 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] USB: ohci-at91: add usb_clk for transition to common
 clk framework
References: <Pine.LNX.4.44L0.1308011038380.1534-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308011038380.1534-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8964978009801324646
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 16:39, Alan Stern wrote:
> On Thu, 1 Aug 2013, Boris BREZILLON wrote:
>
>> The AT91 PMC (Power Management Controller) provides an USB clock used by
>> USB Full Speed host (ohci) and USB Full Speed device (udc).
>> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
>> This configuration was formely done in mach-at91/clock.c, but this
>> implementation will be removed when moving to common clk framework.
>>
>> This patch adds support for usb clock retrieval and configuration, and is
>> backward compatible with the current at91 clk implementation (if usb clk
>> is not found, it does not configure/enable it).
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> @@ -163,6 +169,8 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>>   		goto err5;
>>   	}
>>   
>> +	uclk = clk_get(&pdev->dev, "usb_clk");
> What happens if uclk isn't found but it is needed?
It will not fail but I guess the usb host won't work as the clock won't 
be correctly
configured.

I agree with you: this is not a good solution.

Another option is to keep the previous version of this patch and put 
uclk handling
in "#ifdef CONFIG_COMMON_CLK #endif" sections.

Would this be acceptable ?

>
> Alan Stern
>

