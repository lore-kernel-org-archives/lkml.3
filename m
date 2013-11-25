Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3KYLA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:00:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48490 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYLA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:00:56 -0500
Message-ID: <52932DA1.8040204@ti.com>
Date: Mon, 25 Nov 2013 12:59:45 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <wim@iguana.be>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: Fwd: [PATCH 7/8] watchdog: davinci: add "clocks" property
References: <1383680783-12114-8-git-send-email-ivan.khoronzhuk@ti.com> <527A28E8.4010204@ti.com> <201311231857.47104.arnd@arndb.de>
In-Reply-To: <201311231857.47104.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 07:57 PM, Arnd Bergmann wrote:
> On Wednesday 06 November 2013, ivan.khoronzhuk wrote:
>> @@ -7,6 +7,10 @@ Required properties:
>>   
>>   - reg : Should contain WDT registers location and length
>>   
>> +- clocks: phandle reference to the controller clock.
>> +         Required only for Keystone arch.
>> +         See clock-bindings.txt
>> +
>>   Optional properties:
>>   
>>   - timeout-sec:         Contains the watchdog timeout in seconds
> 
> I think it should really be listed under "Optional properties" and the
> reference to Keystone removed. Note how the binding would need
> to change otherwise if another platform started to use the clock, which
> is a little silly.
> 
> 	Arnd
> 

Ok, I'll move clocks property under "Optional properties" and describe it
as following:

Optional properties:
- timeout-sec : Contains the watchdog timeout in seconds
- clocks: phandle reference to the controller clock.
	  Needed if platform uses clocks.
	  See clock-bindings.txt

FYI:
The new patch series had been already presented, where the patches
"watchdog: davinci: add "clocks" property" and
"watchdog: davinci: reuse driver for keystone arch" were combined.
http://www.spinics.net/lists/devicetree/msg12542.html

-- 
Regards,
Ivan Khoronzhuk
