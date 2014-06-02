Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaFBRrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:47:01 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38964 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaFBRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:46:59 -0400
Date: Mon, 2 Jun 2014 19:46:30 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mike Remski <mremski@mutualink.net>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
Message-ID: <20140602174630.GD13790@localhost>
References: <538C8963.4010909@mutualink.net>
 <20140602143347.GA1902@localhost>
 <538C953B.9020304@mutualink.net>
 <20140602154036.GA8662@localhost>
 <538CA020.4070204@mutualink.net>
 <20140602162027.GB13790@localhost>
 <538CA54C.4040803@mutualink.net>
 <20140602164957.GC13790@localhost>
 <538CB049.9020805@mutualink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CB049.9020805@mutualink.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:11:37PM -0400, Mike Remski wrote:
> On 06/02/2014 12:49 PM, Johan Hovold wrote:
> > On Mon, Jun 02, 2014 at 12:24:44PM -0400, Mike Remski wrote:
> >> On 06/02/2014 12:20 PM, Johan Hovold wrote:
> >>> On Mon, Jun 02, 2014 at 12:02:40PM -0400, Mike Remski wrote:
> >>>> On 06/02/2014 11:40 AM, Johan Hovold wrote:
> >>>>> [ Please avoid top-posting. ]
> >>>>>
> >>>>> On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:

> >>> The third interface lacks endpoints and crashes the ftdi_sio driver.
> >>> This shouldn't happen (even if you're forcing the wrong driver to bind),
> >>> so I'll fix it up if still broken in v3.15-rc.
> >>>
> >> Johan,
> >> Thanks again.  Yes, the device does indeed have an FTDI embedded in it;
> >> they've programmed in their own ids.  They supply a Windows driver for
> >> it, but that doesn't do me any good.  :)
> > Not just their own ID's it seems.
> >
> > Have you tried just using the cdc-acm driver? The ports should up as
> > /dev/ttyACMx instead of ttyUSBx.
> >
> Not yet, next on the list.

You really should try this before anything else. :)

> I'm suspecting that bNumEndpoints == 0 is causing endpoint[1].desc to 
> stay at NULL (line 1567 in 3.1.4.5 source), so by the time it gets used 
> later on, I'm hitting the NULL dereference.

Yeah, the code is obviously broken (also in v3.15-rc). It should
probably work to just return from ftdi_set_max_packet_size if
num_endpoints is 0 if you want to try that (or you can use your ?:
construct), but I should be able to fix this up properly on Wednesday.

Thanks,
Johan
