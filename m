Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaJWPJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:09:46 -0400
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:63744
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039AbaJWPJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:09:44 -0400
Message-ID: <54491947.4010008@opensource.altera.com>
Date: Thu, 23 Oct 2014 10:05:43 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>		 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>	 <1413834151.2010.19.camel@x41> <5446C668.3020609@opensource.altera.com> <1414009627.17121.15.camel@x220>
In-Reply-To: <1414009627.17121.15.camel@x220>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR02CA0023.eurprd02.prod.outlook.com (10.242.225.151) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(377424004)(479174003)(199003)(377454003)(24454002)(189002)(76176999)(19580395003)(93886004)(99136001)(92566001)(50986999)(85306004)(4396001)(15395725005)(92726001)(110136001)(87266999)(85852003)(54356999)(83506001)(64126003)(101416001)(65816999)(15202345003)(97736003)(21056001)(15975445006)(102836001)(77096002)(23676002)(105586002)(95666004)(59896002)(20776003)(120916001)(66066001)(64706001)(47776003)(117636001)(40100003)(65956001)(87976001)(86362001)(122386002)(50466002)(31966008)(42186005)(80022003)(76482002)(107046002)(99396003)(106356001)(46102003)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 03:27 PM, Paul Bolle wrote:
> On Tue, 2014-10-21 at 15:47 -0500, Dinh Nguyen wrote:
>> On 10/20/2014 02:42 PM, Paul Bolle wrote:
>>> (Side note: drivers/usb/dwc2/Kconfig is sourced (in drivers/usb/Kconfig)
>>> even if USB is _not_ set. But USB_DCW2 still depends on USB. Why is
>>> that?)
>>
>> Because USB is for Host-Side support. DWC2 driver should only get built
>> for when USB is enabled. I think you're getting USB and USB_SUPPORT
>> mixed up.
> 
> No, I don't think I did. Because in drivers/usb/Kconfig we see  
>     if USB
> 
>     [...]
> 
>     endif
> 
>     [...]
> 
>     source "drivers/usb/dwc2/Kconfig"
> 
>     [...]

Well, CONFIG_USB enables the host stack that is needed by the DWC2
driver, without CONFIG_USB, the DWC2 driver will not be able to build.

> 
>> In addition, thanks to your comment, I realized that DWC2 should also be
>> available to build when USB_GADGET is enabled. A patch has been sent:
>>
>> http://marc.info/?l=linux-usb&m=141392377124818&w=2
> 
> I haven't checked, but doesn't this mean USB_DWC2 could just depend on
> USB_SUPPORT?
> 
I don't think so because USB_SUPPORT will not select USB or USB_GAGDGET,
and the DWC2 driver will need either 1 or both for it to build correctly.

Dinh

