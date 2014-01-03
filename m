Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaACC5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:57:32 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:34402 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaACC5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:57:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s032tc8Y003931, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "=?iso-8859-1?Q?'Bj=F8rn_Mork'?=" <bjorn@mork.no>
CC: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com><1388633110-1435-1-git-send-email-hayeswang@realtek.com> <877gai8nqu.fsf@nemi.mork.no>
Subject: RE: [PATCH net-next v2 6/6] r8152: support RTL8153
Date: Fri, 3 Jan 2014 10:56:02 +0800
Message-ID: <605671F106F540BA9665A195CACB78A0@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8HxoEHuMtvyZZxTbi2x1z8AGxrLAAaEnOw
In-Reply-To: <877gai8nqu.fsf@nemi.mork.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Bjørn Mork [mailto:bjorn@mork.no] 
> Sent: Thursday, January 02, 2014 10:25 PM
> To: Hayeswang
> Cc: oliver@neukum.org; netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
> 
[...]
> > +#if defined(CONFIG_USB_RTL8152) || 
> defined(CONFIG_USB_RTL8152_MODULE)
> > +/* Samsung USB Ethernet Adapters */
> > +{
> > +	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 
> 0xa101, USB_CLASS_COMM,
> > +			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
> > +	.driver_info = 0,
> > +},
> > +#endif
> 
> 
> We don't play the if-other-driver-is-enabled for any other of the
> blacklisted devices, including other devices supported by the RTL8152
> driver.  Why do we need it here?

The USB nic have two configurations. One is the config 2 which is the ECM
mode and uses the driver of cdc_ether. The other is the config 1 which use
the driver of r8152. When the dangle is plugged, I find the configuration
is 2 and the ECM driver would be loaded. By this way, you could select
which mode you want to run. Some people would select ECM mode for
performance, and the other would select r8152 for power saving.
 
Best Regards,
Hayes

