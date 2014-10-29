Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaJ2BPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:15:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60597 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2BPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:15:14 -0400
Message-ID: <54503F9D.7080808@wwwdotorg.org>
Date: Tue, 28 Oct 2014 19:15:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, linus.walleij@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com> <544ECAB2.3060706@wwwdotorg.org> <544ECFB4.7040704@linux.com> <544EDCB6.7090001@wwwdotorg.org> <544F3FDA.60407@linux.com>
In-Reply-To: <544F3FDA.60407@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 01:03 AM, Matthias Klein wrote:
> 
> Am 28.10.2014 um 01:00 schrieb Stephen Warren:
>> On 10/27/2014 05:05 PM, Matthias Klein wrote:
>>
>>> - To be in sync with the GPIO numbers in the datasheet / documentation
>>
>> I assume that's only relevant because of the second point; the GPIO
>> IDs in DT files already match the datasheet.
>>
>>> - For userland applications which rely on these GPIO numbers
>>
>> This isn't a scalable solution for that; this "fix" can only work for
>> a single GPIO controller in any one system. It'd be better for all
>> usage to search for the correct GPIO controller in sysfs, find the
>> base address of that, and then add on the controller-relative GPIO ID.
>> That way, the same approach is taken irrespective of which GPIO
>> controller is in use, and there are no special cases.
>>
>> Perhaps this could be simplified (removing the need to adding
>> base+offset to get the Linux ID) if the GPIO core exported a
>> per-controller directory in sysfs for GPIO manipulation (the files in
>> which used controller-relative numbering), rather than having a single
>> directory using Linux-internal global GPIO numbering; something like
>> /sys/class/gpio/gpio@7e200000/export which uses ID 0..N vs.
>> /sys/class/gpio/export which uses IDs X..X+N where X is arbitary.
> 
> Would you accept a patch which implements the "gpio-base" property into
> the device tree for pinctrl-bcm2835?

DT is supposed to represent HW features, in an OS-agnostic way, and a
"GPIO base" is a Linux-specific SW concept.
