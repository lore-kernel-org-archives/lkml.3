Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaK1X3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:29:02 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:41427 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaK1X3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:29:00 -0500
Message-ID: <54790537.809@gmail.com>
Date: Fri, 28 Nov 2014 15:28:55 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Hisashi T Fujinaka <htodd@twofifty.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: remove unused variables
References: <1417065728-5592-1-git-send-email-sudipm.mukherjee@gmail.com> <alpine.NEB.2.11.1411262157110.1481@chris.i8u.org> <20141127130725.GA12406@sudip-PC>
In-Reply-To: <20141127130725.GA12406@sudip-PC>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/11/2014 05:07, Sudip Mukherjee a écrit :
> On Wed, Nov 26, 2014 at 09:59:28PM -0800, Hisashi T Fujinaka wrote:
>> I'm pretty sure those double reads are there for a reason, so most of
>> this I'm going to have to check on Monday. We have a long holiday
>> weekend here in the US.
> 
> if the double reads are there for some reason, can you please let me know what that reason might be..

Could be latching, especially in the context of reading from Ethernet
PHYs, some registers are latched, so you may have to do a double read to
ensure the value you get is consistent.

Also, if you do a read that is not stored in any return value, the
compiler is now free to remove that actual read, and that may have other
side effects for registers which are e.g: read to clear, or any of the like.

> 
>>
>> I'm not sure why you're bothering with an old driver like this, but if
>> you haven't actually tried this on all the hardware it pertains to, I'm
>> going want to NAK this.
> 
> no it has not been tested on hardware.  :(
> 
> i am still in the learning process, NAK is also part of learning.
> 
> infact there is another part of the code, which, theoretically, will never get executed. but i didnot dare to send that removal patch without testing on the hardware.
> 
> thanks
> sudip
> 
>>
>> I should do this from my todd.fujinaka@intel.com account but it's 10PM
>> on the first day of a long holiday weekend.
>>
>> On Thu, 27 Nov 2014, Sudip Mukherjee wrote:
>>
>>> these variables were only being assigned some values, but were never
>>> used.
>>>
>>> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
>>> ---
>>> drivers/net/ethernet/intel/e1000/e1000_hw.c   | 142 ++++++++++++--------------
> <snip>
>>> 			case SPEED_100:
>>> -				txb2b = false;
>>> 				/* maybe add some timeout factor ? */
>>> 				break;
>>> 			}
>>>
>>
>> -- 
>> Hisashi T Fujinaka - htodd@twofifty.com
>> BSEE + BSChem + BAEnglish + MSCS + $2.50 = coffee
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

