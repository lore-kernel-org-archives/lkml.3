Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaIHUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:25:44 -0400
Received: from cthulhu.worldbroken.com ([173.230.133.178]:57390 "EHLO
	cthulhu.worldbroken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaIHUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:25:42 -0400
Message-ID: <540E10C3.2080805@worldbroken.com>
Date: Mon, 08 Sep 2014 16:25:39 -0400
From: Bill Pemberton <wfp5p@worldbroken.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: cascardo@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, lidza.louina@gmail.com,
        devel@driverdev.osuosl.org
Subject: Re: [Patch v2 0/2] Move Digi Neo card support from dgnc to jsm
References: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com> <20140908201700.GA28282@kroah.com>
In-Reply-To: <20140908201700.GA28282@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 04:17 PM, Greg KH wrote:
> On Sat, Aug 30, 2014 at 04:35:56PM -0400, wfp5p@worldbroken.com wrote:
>> From: Bill Pemberton <wfp5p@worldbroken.com>
>>
>> The jsm driver (drivers/tty/serial/jsm) already supports the Digi Neo
>> cards that dgnc (staging) supports.  In fact, it appears that jsm was
>> based on dgnc.  The dgnc driver has PCI ids for more cards than jsm,
>> this patch moves support for all the Neo cards to jsm.
>>
>> The result of this will be that dgnc will only support the Classic
>> cards since the jsm driver doesn't support those cards yet.
>>
>>
>> Bill Pemberton (2):
>>    jsm: add support for additional Neo cards
>>    staging: dgnc: remove Neo card ids from device table
>>
>>   drivers/staging/dgnc/dgnc_driver.c  | 13 -------------
>>   drivers/tty/serial/jsm/jsm.h        | 10 ++++++++++
>>   drivers/tty/serial/jsm/jsm_driver.c | 38 +++++++++++++++++++++++++++++++++----
>>   3 files changed, 44 insertions(+), 17 deletions(-)
>
> These are now applied, thanks.
>
> Do you think we can delete the dgnc driver now, or are there still some
> odd cards out there that it only supports?  What would it take to move
> that support to the jsm driver instead?
>

The jsm driver still doesn't support the Classic cards, just the Neo 
cards so dgnc would still be needed to support those cards.

I think the right thing would be to put the Classic support into jsm. 
I've started looking at that.  Dgnc and jsm are obviously from the same 
base, so dgnc can be used as guide on what to do.  However, I don't have 
a Classic card so I wouldn't be able to test any of the Classic support.

-- 
Bill


