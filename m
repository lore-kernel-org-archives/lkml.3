Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3KSOdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:33:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3KSOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:33:53 -0500
Date: Tue, 19 Nov 2013 15:33:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        James Henstridge <james.henstridge@canonical.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <527BB695.9040209@redhat.com>
Message-ID: <alpine.LNX.2.00.1311191533200.6657@pobox.suse.cz>
References: <20131029145139.GA2788@hercules> <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz> <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com> <527BB695.9040209@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Benjamin Tissoires wrote:

> >> [ adding some more CCs ]
> >>
> >> Okay, so apparently we didn't register with input, but only hiddev /
> >> hidraw.
> >>
> >> appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
> >>
> >> Therefore ->input_configured() callback has never been called, and thus we
> >> oops due to appleir->input_dev being NULL when the first raw event is
> >> reported.
> >>
> >> Could you please provide report descriptor of the device?
> >>
> >> The driver apparently relies on it being registered with hid-input, but
> >> for some reason that doesn't happen.
> > 
> > Here is the relevant lsusb output that I think contains what you're
> > asking for (I had to unbind usbhid for it to include the descriptor):
> > 
> > Bus 005 Device 003: ID 05ac:8240 Apple, Inc. Built-in IR Receiver
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               2.00
> > ...
> 
> Ok, thanks for the report. Could you please test the following patch
> which should solve your problem (hopefully)?

James,

any reults from testing Benjamin's patch, please?

-- 
Jiri Kosina
SUSE Labs
