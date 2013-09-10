Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3IJQPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:15:02 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34877 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3IJQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:15:00 -0400
Date: Tue, 10 Sep 2013 19:14:54 +0300
From: Dan Aloni <alonid@postram.com>
To: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: [PATCH bluetooth-next] Bluetooth: Add support for BCM20702A0
 [0a5c, 21e6]
Message-ID: <20130910161453.GA1904@gmail.com>
References: <1378208542-30729-1-git-send-email-alonid@postram.com>
 <20130910154532.GB1916@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910154532.GB1916@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 04:45:32PM +0100, Gustavo Padovan wrote:
> Hi Dan,
> 
> 2013-09-03 Dan Aloni <alonid@postram.com>:
> 
> > Tested with this patch and a Bluetooth mouse on 3.10.10, on ThinkPad W530.
> > 
> > Bus 001 Device 004: ID 0a5c:21e6 Broadcom Corp. BCM20702 Bluetooth 4.0 [ThinkPad]
> > 
> > T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
> > D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> > P:  Vendor=0a5c ProdID=21e6 Rev=01.12
> > S:  Manufacturer=Broadcom Corp
> > S:  Product=BCM20702A0
> > S:  SerialNumber=F4B7E2F6E438
> > C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> > I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> > I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> > I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> > I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> > 
> > Signed-off-by: Dan Aloni <alonid@postram.com>
> > ---
> >  drivers/bluetooth/btusb.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> > index de4cf4d..e6313f8 100644
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -104,6 +104,7 @@ static struct usb_device_id btusb_table[] = {
> >  	{ USB_DEVICE(0x0b05, 0x17b5) },
> >  	{ USB_DEVICE(0x04ca, 0x2003) },
> >  	{ USB_DEVICE(0x0489, 0xe042) },
> > +	{ USB_DEVICE(0x0a5c, 0x21e6) },
> 
> In which kernel have you seen this issue? We have a generic rule to catch all
> 0x0a5c Broadcom devices. And before we added this the device ID for your
> device was there, so in theory your device always worked.

Seem you are correct. I verified just now that on 3.10.11 the device is 
detected without the patch.

Originally I rebased this patch for my laptop's kernel without noticing it 
isn't needed anymore.

-- 
Dan Aloni
