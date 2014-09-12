Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaILOMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:12:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46850 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbaILOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:12:03 -0400
Message-ID: <5412FF2C.5020600@ti.com>
Date: Fri, 12 Sep 2014 19:41:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com> <5411B93F.3030405@ti.com> <20140912134911.GA30816@xps8300>
In-Reply-To: <20140912134911.GA30816@xps8300>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 12 September 2014 07:19 PM, Heikki Krogerus wrote:
> On Thu, Sep 11, 2014 at 08:31:19PM +0530, Kishon Vijay Abraham I wrote:
>>> @@ -60,22 +59,33 @@ int dwc3_host_init(struct dwc3 *dwc)
>>>  		goto err1;
>>>  	}
>>>  
>>> +	phy_create_lookup(dwc->usb2_generic_phy, "usb2-phy",
>>> +			  dev_name(&xhci->dev));
>>> +	phy_create_lookup(dwc->usb3_generic_phy, "usb3-phy",
>>> +			  dev_name(&xhci->dev));
>>> +
>>
>> I don't think create lookup should be in host init. If it's dt boot, the
>> binding should be in dt data or for other boot modes the bindig should be done
>> in the board file. This just seems hacky to me.
> 
> So are you now suggesting that instead of using platform independent
> solution of sharing the PHYs here, you would have us add platform
> specific quirks? That would be totally wrong!

No. The binding between the controller and the PHY is done in hardware design
and it would be wrong to create such a binding in drivers/* IMO.
> 
> And please don't even consider use of board files especially if there
> is an option. They are the one thing that we are meant to avoid if
> possible! No?

For dt yes, I'm not sure about other modes.

So in the case of dt boot, I'd prefer giving the binding in dt file than
anywhere else.

Thanks
Kishon
