Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaANLpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:45:46 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:48255 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaANLpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:45:43 -0500
Message-ID: <52D52362.4080700@mev.co.uk>
Date: Tue, 14 Jan 2014 11:45:38 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>, Joe Perches <joe@perches.com>
CC: Chase Southwood <chase.southwood@yahoo.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: move trailing statement to next line
 in ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389669374.24849.30.camel@joe-AO722> <20140114072344.GL7444@mwanda>
In-Reply-To: <20140114072344.GL7444@mwanda>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-14 07:23, Dan Carpenter wrote:
> On Mon, Jan 13, 2014 at 07:16:14PM -0800, Joe Perches wrote:
>> On Mon, 2014-01-13 at 21:13 -0600, Chase Southwood wrote:
>>> This patch for ni_mio_common.c silences a checkpatch error due to a
>>> trailing statement.
>> []
>>> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
>> []
>>> @@ -692,7 +692,8 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>>>   		/*  Flush the 6143 data FIFO */
>>>   		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>>>   		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
>>> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
>>> +		while (ni_readl(AIFIFO_Status_6143) & 0x10)
>>> +			;	/*  Wait for complete */
>>
>> It's generally better to use timeouts too.
>
> Just to clarify what Joe is saying do:
>
> 		/*  Wait for complete */
> 		while (timemout < TIMEOUT) {
> 			if (ni_readl(AIFIFO_Status_6143) & 0x10)
> 				break;
> 			udelay(1);
> 		}
>
> I added in a delay...  The problem is that you'd probably have to look
> at the hardware spec to know what timeout to use or if the delay is
> needed.

Some longish timeout of, say, 10000 iterations (~ 0.01 seconds) would 
probably do as it's not that time critical.

We wouldn't expect code clean-up patches to have to deal with that sort 
of thing though.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
