Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaIPGhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:37:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49909 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaIPGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:37:09 -0400
Message-ID: <5417DA8C.1080301@ti.com>
Date: Tue, 16 Sep 2014 12:07:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com> <5411B93F.3030405@ti.com> <20140912134911.GA30816@xps8300> <5412FF2C.5020600@ti.com> <20140915120654.GA31453@xps8300>
In-Reply-To: <20140915120654.GA31453@xps8300>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 15 September 2014 05:36 PM, Heikki Krogerus wrote:
> On Fri, Sep 12, 2014 at 07:41:56PM +0530, Kishon Vijay Abraham I wrote:
>>>> I don't think create lookup should be in host init. If it's dt boot, the
>>>> binding should be in dt data or for other boot modes the bindig should be done
>>>> in the board file. This just seems hacky to me.
>>>
>>> So are you now suggesting that instead of using platform independent
>>> solution of sharing the PHYs here, you would have us add platform
>>> specific quirks? That would be totally wrong!
>>
>> No. The binding between the controller and the PHY is done in hardware design
>> and it would be wrong to create such a binding in drivers/* IMO.
> 
> And kernel of course always knows the hardware design when it's being
> booted, wrong!

Exactly my point. By creating the binding in drivers/*, you are directly
telling the driver of the hardware design whereas it should have come from dt
or platform data or .. (ACPI?).
> 
> Firstly, don't assume this kind of controllers are always part of some
> SoC or chip set. They could easily be on a PCI card for example.

Agreed. Not convinced the current phy-core could handle it well.
> Secondly, don't assume we could tell all the details about the board
> based on some identifiers. Fox example, at least with our SoCs we
> won't be able to differentiate the boards. And it's not like every
> board using the same SoC uses the same USB2 PHY for example. That kind
> of things are up to the manufacturers.

right. In dt, generally we have different dt files for different boards,
similarly we have different board files for different boards where those
bindings can be created. Again not sure about ACPI.
> 
> By default we have to rely on hardware descriptions like DT and ACPI
> tables or being able to runtime detect (ULPI). If those things don't
> work, we live without PHY in this case. We add board specific quirks
> _only_ in case of exceptions, where we simply have no other way. If
> it's possible to avoid them, especially with something as simple as
> this, we avoid them!
> 
>>> And please don't even consider use of board files especially if there
>>> is an option. They are the one thing that we are meant to avoid if
>>> possible! No?
>>
>> For dt yes, I'm not sure about other modes.
>>
>> So in the case of dt boot, I'd prefer giving the binding in dt file than
>> anywhere else.
> 
> I don't know how dt works, but at least in case of ACPI we still need
> to deliver the PHY to xHCI here, even when dwc3 is provided bindings
> to a PHY(s).

Agreed. But can't we have the bindings for xHCI in ACPI itself?

Thanks
Kishon
