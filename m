Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBNJWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:22:13 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:51749
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaBNJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:22:09 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzbb2dI98dI9371I936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh19b6n1155h)
Date: Fri, 14 Feb 2014 10:21:52 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Michal Simek <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Srikanth Thokala <srikanth.thokala@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/14] net: axienet: Removed checkpatch errors/warnings
References: <cover.1392220536.git.michal.simek@xilinx.com>  <75b669c0a947effe74b291093abfa8c71f83736a.1392220536.git.michal.simek@xilinx.com>  <1392251494.2214.11.camel@joe-AO722>  <ff5b1f6a-a6a7-405c-9e83-59ad33852b93@TX2EHSMHS044.ehs.local> <1392306707.2214.65.camel@joe-AO722>
In-Reply-To: <1392306707.2214.65.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <6d50c843-86d3-4333-ac6f-9901dbad36ed@AM1EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 04:51 PM, Joe Perches wrote:
> On Thu, 2014-02-13 at 08:19 +0100, Michal Simek wrote:
>> On 02/13/2014 01:31 AM, Joe Perches wrote:
>>> On Wed, 2014-02-12 at 16:55 +0100, Michal Simek wrote:
> 
> Hi again Michal.
> 
>>>> +		netdev_warn(lp->ndev,
>>>> +			 "Could not find clock ethernet controller property.");
>>>
>>> here too. (and alignment)
>>
>> This is problematic. I would like to keep 80 char limits and keeping
>> this align just break it. That's why I was using tab alignment.
>> Probably the solution is just to shorten message.
> 
> (overly long, tiresomely trivial stuff below)
> 
> Your choice.  I'm not an 80 column zealot but
> please don't shorten the message just to fit
> 80 columns if it impacts intelligibility.

I am trying to keep 80 chars and follow subsystem
standards.

> Generally, I'd write this something like:
> 
> 		netdev_warn(lp->ndev,
> 			    "Could not find clock ethernet controller property\n");
> 
> (without the period) which is 83 columns.

ok.

> checkpatch makes exceptions for 80 column line
> length maximums for format strings.

yes but testing systems reports it because that 80 chars
is still default value.


> 
> I've no real issue if you indent it back one.
> 
> fyi: this is 77 columns
> 
> 		netdev_warn(lp->ndev,
> 			    "No clock ethernet controller property found\n");
> 
> About the message itself.
> 
> You dropped the "axienet_mdio_setup" function name.
> 
> I believe the dmesg output will look something like:
> 
> xilinx_temac 0000:01:00.0 (unregistered net_device): Could not find clock ethernet controller property.
> xilinx_temac 0000:01:00.0 (unregistered net_device): Setting MDIO clock divisor to default 29
> 
> Because these 2 messages are effectively linked,
> my preference would be to emit them on a single line,
> 
> Something like:
> 
> xilinx_temac 0000:01:00.0 (unregistered net_device): of_get_property("clock-frequency") not found - setting MDIO clock divisor to default 29
> 
> or
> 
> 		netdev_warn(lp->ndev,
> 			    "of_get_property(\"clock-frequency\") not found - setting MDIO clock divisor to default %u\n",
> 			    DEFAULT_CLOCK_DIVISOR);
> 

But then you are breaking 80 char limits a lot.

Thanks,
Michal


