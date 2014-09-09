Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaIIKeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:34:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36361 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaIIKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:34:01 -0400
Message-ID: <540ED794.5020701@mev.co.uk>
Date: Tue, 9 Sep 2014 11:33:56 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: amplc_pci230: fix DACOUT write
References: <1408447956-10139-1-git-send-email-abbotti@mev.co.uk> <20140908191445.GA32320@kroah.com> <DC148C5AA1CEBA4E87973D432B1C2D8825F903DB@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F903DB@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-08 20:34, Hartley Sweeten wrote:
> On Monday, September 08, 2014 12:15 PM, Greg Kroah-Hartman wrote:
>> On Tue, Aug 19, 2014 at 12:32:36PM +0100, Ian Abbott wrote:
>>> Commit 4f9c63fe5333b27ab23ed399830c7977f6970744 ("staging: comedi:
>>> amplc_pci230: refactor iobase addresses") removed some parentheses
>>> (presumably to keep the line withing 80 chars) in
>>> `pci230_ao_write_nofifo()` when writing to the DACOUT1 or DACOUT2
>>> registers, but it removed the wrong parentheses.  Fix it.
>>>
>>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>>> ---
>>> This bug is in linux-next master and staging-next.
>>> ---
>>>   drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
>>> index 0fd212f..dd69e47 100644
>>> --- a/drivers/staging/comedi/drivers/amplc_pci230.c
>>> +++ b/drivers/staging/comedi/drivers/amplc_pci230.c
>>> @@ -628,7 +628,7 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
>>>
>>>   	/* Write mangled datum to appropriate DACOUT register. */
>>>   	outw(pci230_ao_mangle_datum(dev, datum),
>>> -	     devpriv->daqio + ((chan) == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2);
>>> +	     devpriv->daqio + (chan == 0 ? PCI230_DACOUT1 : PCI230_DACOUT2));
>>>   }
>>>
>>>   static inline void pci230_ao_write_fifo(struct comedi_device *dev,
>>> --
>>> 2.0.4
>>
>> This doesn't apply to my tree anymore, is it still needed?
>
> Looks like you already applied a similar patch from Dan Carpenter:
>
> commit 94254d1baec765b22cc5df3a9a16a8cc9a79d406
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Tue Aug 26 10:55:51 2014 +0300
>
>      staging: comedi: amplc_pci230: fix a precedence bug

No, it's no longer needed.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
