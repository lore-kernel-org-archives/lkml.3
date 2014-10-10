Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaJJJMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:12:16 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:38281 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJJJMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:12:13 -0400
X-ASG-Debug-ID: 1412932331-0759e74828417370002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Fri, 10 Oct 2014 11:12:09 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Johan Hovold <johan@kernel.org>
CC: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010091209.GC3588@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
 <20141010090117.GA12494@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20141010090117.GA12494@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412932331
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10404
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:01:17AM +0200, Johan Hovold wrote:
> On Fri, Oct 10, 2014 at 10:44:54AM +0200, Frans Klaver wrote:
> > Add new IDs for the Xsens Awinda Station and Awinda Dongle.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> > ---
> >  drivers/usb/serial/ftdi_sio.c     | 2 ++
> >  drivers/usb/serial/ftdi_sio_ids.h | 2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> > index dc72b92..4969875 100644
> > --- a/drivers/usb/serial/ftdi_sio.c
> > +++ b/drivers/usb/serial/ftdi_sio.c
> > @@ -663,6 +663,8 @@ static const struct usb_device_id id_table_combined[] = {
> >  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
> >  	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
> >  	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
> > +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
> > +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
> 
> Could you keep the XSENS_VID entries sorted alphabetically here?

Sure thing. Should have been obvious.

> >  	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
> >  	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
> >  	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
> > diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> > index 5937b2d..be3fffe 100644
> > --- a/drivers/usb/serial/ftdi_sio_ids.h
> > +++ b/drivers/usb/serial/ftdi_sio_ids.h
> > @@ -145,6 +145,8 @@
> >  #define XSENS_VID		0x2639
> >  #define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
> >  #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
> > +#define XSENS_AWINDA_STATION_PID 0x0101
> > +#define XSENS_AWINDA_DONGLE_PID 0x0102
> 
> And sorted by PID here (even though the two current entries are not, you
> could reorder them as well).
> 
> I noticed that the below PIDs use the FTDI VID. Perhaps a comment or at
> least a separating empty line would be appropriate.
> 
> >  #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
> >  #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
> >  #define XSENS_CONVERTER_2_PID	0xD38A

I'll move the new entries up. How about I throw in a separate patch that
cleans up stuff around the PID definitions? There's some alignment off
as well. That doesn't need to go into stable, I think.

Thanks,
Frans
