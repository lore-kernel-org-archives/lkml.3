Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaIKLw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:52:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59970 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaIKLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:52:57 -0400
Message-ID: <54118D13.3010608@atmel.com>
Date: Thu, 11 Sep 2014 13:52:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Johan Hovold <johan@kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 0/8] rtc: at91sam9: add DT support
References: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>	<20140911093942.GA12295@localhost> <20140911120659.14daa624@bbrezillon>
In-Reply-To: <20140911120659.14daa624@bbrezillon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 12:06, Boris BREZILLON :
> On Thu, 11 Sep 2014 11:39:42 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
>> On Thu, Sep 11, 2014 at 10:55:59AM +0200, Boris BREZILLON wrote:
>>
>>> Johan, let me know if this version addresses part of your concerns.
>>
>> Looks good to me. I just have a few minor comments on two of the patches.
>>
>>> I'm open to any suggestion/rework to address other previously discussed
>>> issues, as long as it does not end up in a dead-end (like the discussion
>>> you had last year):
>>>  - the fact that the RTT block could be used for something that is not
>>>    an RTC
>>>  - the fact that referencing the GPBR node and defining a GPBR register
>>>    number to store RTC time info could be considered as an HW config and
>>>    not an HW description and thus should not be described in the DT
>>
>> No doubt.
> 
> Okay then. Any suggestion to do otherwise ?
> Alexandre suggested to pass the GPBR register number through a module
> parameter, and retrieve the GPBR syscon by searching for a gpbr node
> (or atmel,at91sam9260-gpbr compatible node) in the device tree.
> 
> I'm not a big fan of this solution, as it implies passing driver
> specific config to the global cmdline (and we'll have to handle the
> 9263 case where 2 RTT blocks are availables).

Nope, I don't like messing with the cmdline for something like that.

atmel,rtt-rtc-time-reg = <&gpbr 0x0>;
is perfectly fine for me.

Bye,
-- 
Nicolas Ferre
