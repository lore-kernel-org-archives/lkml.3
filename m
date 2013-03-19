Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3CSQez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:34:55 -0400
Received: from mout.gmx.net ([212.227.17.20]:50107 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab3CSQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:34:53 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19Frn4ixiNFBo5fYM5XgzVsQbIMhAAa2hx/221uVj
	Ef8FwpGqXdrzDF
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI controllers
References: <20130318210510.203500214@linuxfoundation.org>
	<20130318210511.127988921@linuxfoundation.org>
Date: Tue, 19 Mar 2013 17:34:47 +0100
In-Reply-To: <20130318210511.127988921@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Mon, 18 Mar 2013 14:06:35 -0700")
Message-ID: <87mwtzjql4.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-18 22:06 +0100, Greg Kroah-Hartman wrote:

> 3.8-stable review patch.  If anyone has any objections, please let me know.

This patch breaks resume from suspend on my system if the following
device is plugged in:

,----
| $ lsusb | head -n1
| Bus 005 Device 002: ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT2571W]
`----

The same problem exists in 3.9-rc3, FWIW.

Detailed lsusb output follows, I'll be happy to provide more information
if needed.

,----
| # lsusb -s 005: -v
| Bus 005 Device 002: ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT2571W]
| Device Descriptor:
|   bLength                18
|   bDescriptorType         1
|   bcdUSB               2.00
|   bDeviceClass            0 (Defined at Interface level)
|   bDeviceSubClass         0 
|   bDeviceProtocol         0 
|   bMaxPacketSize0        64
|   idVendor           0x07d1 D-Link System
|   idProduct          0x3c03 AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT2571W]
|   bcdDevice            0.01
|   iManufacturer           1 Ralink
|   iProduct                2 802.11 bg WLAN
|   iSerial                 0 
|   bNumConfigurations      1
|   Configuration Descriptor:
|     bLength                 9
|     bDescriptorType         2
|     wTotalLength           32
|     bNumInterfaces          1
|     bConfigurationValue     1
|     iConfiguration          0 
|     bmAttributes         0x80
|       (Bus Powered)
|     MaxPower              300mA
|     Interface Descriptor:
|       bLength                 9
|       bDescriptorType         4
|       bInterfaceNumber        0
|       bAlternateSetting       0
|       bNumEndpoints           2
|       bInterfaceClass       255 Vendor Specific Class
|       bInterfaceSubClass    255 Vendor Specific Subclass
|       bInterfaceProtocol    255 Vendor Specific Protocol
|       iInterface              0 
|       Endpoint Descriptor:
|         bLength                 7
|         bDescriptorType         5
|         bEndpointAddress     0x81  EP 1 IN
|         bmAttributes            2
|           Transfer Type            Bulk
|           Synch Type               None
|           Usage Type               Data
|         wMaxPacketSize     0x0200  1x 512 bytes
|         bInterval               0
|       Endpoint Descriptor:
|         bLength                 7
|         bDescriptorType         5
|         bEndpointAddress     0x01  EP 1 OUT
|         bmAttributes            2
|           Transfer Type            Bulk
|           Synch Type               None
|           Usage Type               Data
|         wMaxPacketSize     0x0200  1x 512 bytes
|         bInterval               0
| Device Qualifier (for other device speed):
|   bLength                10
|   bDescriptorType         6
|   bcdUSB               2.00
|   bDeviceClass            0 (Defined at Interface level)
|   bDeviceSubClass         0 
|   bDeviceProtocol         0 
|   bMaxPacketSize0        64
|   bNumConfigurations      1
| Device Status:     0x0000
|   (Bus Powered)
| 
| Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
| Device Descriptor:
|   bLength                18
|   bDescriptorType         1
|   bcdUSB               2.00
|   bDeviceClass            9 Hub
|   bDeviceSubClass         0 Unused
|   bDeviceProtocol         0 Full speed (or root) hub
|   bMaxPacketSize0        64
|   idVendor           0x1d6b Linux Foundation
|   idProduct          0x0002 2.0 root hub
|   bcdDevice            3.08
|   iManufacturer           3 Linux 3.8.3-nouveau ehci_hcd
|   iProduct                2 EHCI Host Controller
|   iSerial                 1 0000:00:1d.7
|   bNumConfigurations      1
|   Configuration Descriptor:
|     bLength                 9
|     bDescriptorType         2
|     wTotalLength           25
|     bNumInterfaces          1
|     bConfigurationValue     1
|     iConfiguration          0 
|     bmAttributes         0xe0
|       Self Powered
|       Remote Wakeup
|     MaxPower                0mA
|     Interface Descriptor:
|       bLength                 9
|       bDescriptorType         4
|       bInterfaceNumber        0
|       bAlternateSetting       0
|       bNumEndpoints           1
|       bInterfaceClass         9 Hub
|       bInterfaceSubClass      0 Unused
|       bInterfaceProtocol      0 Full speed (or root) hub
|       iInterface              0 
|       Endpoint Descriptor:
|         bLength                 7
|         bDescriptorType         5
|         bEndpointAddress     0x81  EP 1 IN
|         bmAttributes            3
|           Transfer Type            Interrupt
|           Synch Type               None
|           Usage Type               Data
|         wMaxPacketSize     0x0004  1x 4 bytes
|         bInterval              12
| Hub Descriptor:
|   bLength              11
|   bDescriptorType      41
|   nNbrPorts             8
|   wHubCharacteristic 0x000a
|     No power switching (usb 1.0)
|     Per-port overcurrent protection
|   bPwrOn2PwrGood       10 * 2 milli seconds
|   bHubContrCurrent      0 milli Ampere
|   DeviceRemovable    0x00 0x00
|   PortPwrCtrlMask    0xff 0xff
|  Hub Port Status:
|    Port 1: 0000.0100 power
|    Port 2: 0000.0100 power
|    Port 3: 0000.0100 power
|    Port 4: 0000.0100 power
|    Port 5: 0000.0100 power
|    Port 6: 0000.0503 highspeed power enable connect
|    Port 7: 0000.0100 power
|    Port 8: 0000.0100 power
| Device Status:     0x0001
|   Self Powered
`----

Cheers,
       Sven


> From: Alan Stern <stern@rowland.harvard.edu>
>
> commit 6402c796d3b4205d3d7296157956c5100a05d7d6 upstream.
>
> This patch (as1660) works around a hardware problem present in some
> (if not all) Intel EHCI controllers.  After a QH has been unlinked
> from the async schedule and the corresponding IAA interrupt has
> occurred, the controller is not supposed access the QH and its qTDs.
> There certainly shouldn't be any more DMA writes to those structures.
> Nevertheless, Intel's controllers have been observed to perform a
> final writeback to the QH's overlay region and to the most recent qTD.
> For more information and a test program to determine whether this
> problem is present in a particular controller, see
>
> 	http://marc.info/?l=linux-usb&m=135492071812265&w=2
> 	http://marc.info/?l=linux-usb&m=136182570800963&w=2
>
> This patch works around the problem by always waiting for two IAA
> cycles when unlinking an async QH.  The extra IAA delay gives the
> controller time to perform its final writeback.
>
> Surprisingly enough, the effects of this silicon bug have gone
> undetected until quite recently.  More through luck than anything
> else, it hasn't caused any apparent problems.  However, it does
> interact badly with the path that follows this one, so it needs to be
> addressed.
>
> This is the first part of a fix for the regression reported at:
>
> 	https://bugs.launchpad.net/bugs/1088733
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Stephen Thirlwall <sdt@dr.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/usb/host/ehci-hcd.c |    6 ++----
>  drivers/usb/host/ehci-q.c   |   18 ++++++++++++++----
>  2 files changed, 16 insertions(+), 8 deletions(-)
>
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -748,11 +748,9 @@ static irqreturn_t ehci_irq (struct usb_
>  		/* guard against (alleged) silicon errata */
>  		if (cmd & CMD_IAAD)
>  			ehci_dbg(ehci, "IAA with IAAD still set?\n");
> -		if (ehci->async_iaa) {
> +		if (ehci->async_iaa)
>  			COUNT(ehci->stats.iaa);
> -			end_unlink_async(ehci);
> -		} else
> -			ehci_dbg(ehci, "IAA with nothing unlinked?\n");
> +		end_unlink_async(ehci);
>  	}
>  
>  	/* remote wakeup [4.3.1] */
> --- a/drivers/usb/host/ehci-q.c
> +++ b/drivers/usb/host/ehci-q.c
> @@ -1170,7 +1170,7 @@ static void single_unlink_async(struct e
>  	struct ehci_qh		*prev;
>  
>  	/* Add to the end of the list of QHs waiting for the next IAAD */
> -	qh->qh_state = QH_STATE_UNLINK;
> +	qh->qh_state = QH_STATE_UNLINK_WAIT;
>  	if (ehci->async_unlink)
>  		ehci->async_unlink_last->unlink_next = qh;
>  	else
> @@ -1213,9 +1213,19 @@ static void start_iaa_cycle(struct ehci_
>  
>  		/* Do only the first waiting QH (nVidia bug?) */
>  		qh = ehci->async_unlink;
> -		ehci->async_iaa = qh;
> -		ehci->async_unlink = qh->unlink_next;
> -		qh->unlink_next = NULL;
> +
> +		/*
> +		 * Intel (?) bug: The HC can write back the overlay region
> +		 * even after the IAA interrupt occurs.  In self-defense,
> +		 * always go through two IAA cycles for each QH.
> +		 */
> +		if (qh->qh_state == QH_STATE_UNLINK_WAIT) {
> +			qh->qh_state = QH_STATE_UNLINK;
> +		} else {
> +			ehci->async_iaa = qh;
> +			ehci->async_unlink = qh->unlink_next;
> +			qh->unlink_next = NULL;
> +		}
>  
>  		/* Make sure the unlinks are all visible to the hardware */
>  		wmb();
