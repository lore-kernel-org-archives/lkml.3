Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3HARaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:30:06 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49812 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3HARaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:30:04 -0400
Message-ID: <51FA9B20.3080304@cogentembedded.com>
Date: Thu, 01 Aug 2013 21:30:08 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: boris brezillon <b.brezillon@overkiz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ohci-at91: add usb_clk for transition to common
 clk framework
References: <Pine.LNX.4.44L0.1308011153180.1534-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308011153180.1534-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/01/2013 07:56 PM, Alan Stern wrote:

>>> What happens if uclk isn't found but it is needed?

>> It will not fail but I guess the usb host won't work as the clock won't
>> be correctly
>> configured.

>> I agree with you: this is not a good solution.

>> Another option is to keep the previous version of this patch and put
>> uclk handling
>> in "#ifdef CONFIG_COMMON_CLK #endif" sections.

>> Would this be acceptable ?

> Yes.  However, a more elegant approach is to protect the relevant
> statements with: if (defined(CONFIG_COMMON_CLK)).  This preprocessor

    You probably meant IS_ENABLED() or IS_BUIILTIN()? Or is there something I 
don't know about gcc preprocessor?

> evaluates this to a 0 or 1, so the compiler will not generate output
> for the protected source code if the symbol isn't defined.

> Alan Stern

WBR, Sergei

