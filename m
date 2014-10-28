Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaJ1AKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:10:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45021 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaJ1AKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:10:17 -0400
Message-ID: <544EDCB6.7090001@wwwdotorg.org>
Date: Mon, 27 Oct 2014 18:00:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, linus.walleij@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com> <544ECAB2.3060706@wwwdotorg.org> <544ECFB4.7040704@linux.com>
In-Reply-To: <544ECFB4.7040704@linux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 05:05 PM, Matthias Klein wrote:
>
> Am 27.10.2014 um 23:44 schrieb Stephen Warren:
>> On 10/27/2014 04:09 PM, Matthias Klein wrote:
>>> Numerate the GPIOs from 0..53 instead of 202..255.
>>
>> What's the motivation for this? The GPIO IDs should all come from DT,
>> which encodes everything as an ID relative to a particular
>> controllers, and hence the actual value of the base address should be
>> irrelevant.
 >
> - To be in sync with the GPIO numbers in the datasheet / documentation

I assume that's only relevant because of the second point; the GPIO IDs 
in DT files already match the datasheet.

> - For userland applications which rely on these GPIO numbers

This isn't a scalable solution for that; this "fix" can only work for a 
single GPIO controller in any one system. It'd be better for all usage 
to search for the correct GPIO controller in sysfs, find the base 
address of that, and then add on the controller-relative GPIO ID. That 
way, the same approach is taken irrespective of which GPIO controller is 
in use, and there are no special cases.

Perhaps this could be simplified (removing the need to adding 
base+offset to get the Linux ID) if the GPIO core exported a 
per-controller directory in sysfs for GPIO manipulation (the files in 
which used controller-relative numbering), rather than having a single 
directory using Linux-internal global GPIO numbering; something like 
/sys/class/gpio/gpio@7e200000/export which uses ID 0..N vs. 
/sys/class/gpio/export which uses IDs X..X+N where X is arbitary.
