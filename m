Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3CMLsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:48:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42148 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab3CMLsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:48:23 -0400
Message-ID: <5140677B.4030505@ti.com>
Date: Wed, 13 Mar 2013 13:48:11 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 12/12] USB: ehci-omap: Fix detection in HSIC mode
References: <Pine.LNX.4.44L0.1303121201050.2153-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303121201050.2153-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:07 PM, Alan Stern wrote:
> On Tue, 12 Mar 2013, Roger Quadros wrote:
> 
>> The HSIC devices need to be kept in reset while the EHCI controller
>> is being initialized and only brought out of reset after the
>> initialization is complete, else HSIC devices will not be detected.
> 
> This is not a great description of what the patch does.  You should say
> that it moves PHY initialization until after EHCI initialization is
> complete, instead of initializing the PHYs first, shutting them down
> again, and then initializing them a second time.
> 

Okay will update the description.

>> Also remove outdated TODO list from header.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> ---
>>  drivers/usb/host/ehci-omap.c |   38 +++++++++++++++-----------------------
>>  1 files changed, 15 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>> index 1ba1df8..dc2de47 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
>> @@ -29,12 +29,6 @@
>>   * along with this program; if not, write to the Free Software
>>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
>>   *
>> - * TODO (last updated Feb 27, 2010):
>> - *	- add kernel-doc
>> - *	- enable AUTOIDLE
>> - *	- add suspend/resume
>> - *	- add HSIC and TLL support
>> - *	- convert to use hwmod and runtime PM
>>   */
>>  
>>  #include <linux/kernel.h>
>> @@ -90,26 +84,13 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
>>  static int omap_ehci_init(struct usb_hcd *hcd)
>>  {
>>  	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
>> -	struct omap_hcd	*omap = (struct omap_hcd *)ehci->priv;
>> -	int rc, i;
>> -
>> -	/* Hold PHYs in reset while initializing EHCI controller */
>> -	for (i = 0; i < omap->nports; i++) {
>> -		if (omap->phy[i])
>> -			usb_phy_shutdown(omap->phy[i]);
>> -	}
>> +	int rc;
>>  
>>  	/* we know this is the memory we want, no need to ioremap again */
>>  	ehci->caps = hcd->regs;
>>  
>>  	rc = ehci_setup(hcd);
>>  
>> -	/* Bring PHYs out of reset */
>> -	for (i = 0; i < omap->nports; i++) {
>> -		if (omap->phy[i])
>> -			usb_phy_init(omap->phy[i]);
>> -	}
>> -
>>  	return rc;
>>  }
> 
> Now that there's almost nothing left of this function, you can get rid
> of it completely.  Move the assignment to ehci->caps into
> ehci_hcd_omap_probe() and remove the init entry in the overrides
> structure.

Right. Sounds good.

cheers,
-roger
