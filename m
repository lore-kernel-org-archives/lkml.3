Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaCDUWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:22:03 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:43577 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaCDUV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:21:59 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 15:21:59 EST
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Message-id: <53163247.8000904@gmail.com>
Date: Tue, 04 Mar 2014 22:06:31 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
Cc: chris@printf.net, michal.simek@xilinx.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v2] mmc: sdhci: add quirk for broken write protect detection
References: <1393759200-22819-1-git-send-email-eli.billauer@gmail.com>
 <74003aec-1707-4f43-b947-df148d573fa1@TX2EHSMHS038.ehs.local>
In-reply-to: <74003aec-1707-4f43-b947-df148d573fa1@TX2EHSMHS038.ehs.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sören,

wp-inverted solves the practical problem indeed, and fools the driver 
into thinking that the card has an inverted write protection sensor, and 
the logic zero that it finds in the hardware register means that the 
card isn't write protected.

I'm insisting on this patch, because I think that the device tree should 
describe the hardware as it is, and not fool the driver into behaving 
the way we want it to. These tricks always bite back later on.

Regards,
    Eli

On 04/03/14 21:26, Sören Brinkmann wrote:
> Hi Eli,
>
> On Sun, 2014-03-02 at 01:20PM +0200, Eli Billauer wrote:
>    
>> The write protection signal is absent on a board based upon Xilinx' Zynq
>> processor ("ZyBo"). This leads the kernel to think that the MicroSD card is
>> write protected, and causes a kernel panic during boot, as root fails to
>> mount RW.
>>      
> I talked to some people here at Xilinx. According to them, you have the
> option to pin out the WP signal, which would mean the board needs to
> tie/connect the signal properly. Or, if you select to not pin out the WP
> signal, it should be tied to 0 within the chip.
> Currently, I have some doubts that is the case, since Mike reported the
> same issue, but would you mind double checking?
> In theory the signal should default to logic zero which would at most
> require to add the, already existing, 'wp-inverted' quirk when using
> micro-sd on Zynq.
>
> 	Thanks,
> 	Sören
>
>
>
>    


