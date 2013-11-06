Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3KFRNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:13:20 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47902 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3KFRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:13:18 -0500
X-Originating-IP: 83.155.44.161
Message-ID: <1383757993.2554.0.camel@nuvo>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer dereference
From: Bastien Nocera <hadess@hadess.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        James Henstridge <james.henstridge@canonical.com>,
        Fabien =?ISO-8859-1?Q?Andr=E9?= <fabien.andre@gmail.com>
Date: Wed, 06 Nov 2013 18:13:13 +0100
In-Reply-To: <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
References: <20131029145139.GA2788@hercules>
	 <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1 (3.10.1-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 16:38 +0100, Jiri Kosina wrote:
> On Tue, 29 Oct 2013, Luis Henriques wrote:
> 
> > James has reported a NULL pointer dereference[1] on the appleir
> > driver.  From the bug report[2] it looks like it is 100%
> > reproducible using a 3.12-rc6 kernel simply by pressing any button on
> > the IR remote.
> > 
> > >From the stack trace, it looks like input_event is invoked with the
> > input_dev parameter set to NULL, which seems to indicate that
> > appleir_input_configured is never invoked.
> > 
> > Any ideas?
> > 
> > [1] https://launchpadlibrarian.net/154942024/macmini-oops.jpg
> > [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1244505
> 
> [ adding some more CCs ]
> 
> Okay, so apparently we didn't register with input, but only hiddev / 
> hidraw.
> 
> appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
> 
> Therefore ->input_configured() callback has never been called, and thus we 
> oops due to appleir->input_dev being NULL when the first raw event is 
> reported.
> 
> Could you please provide report descriptor of the device?
> 
> The driver apparently relies on it being registered with hid-input, but 
> for some reason that doesn't happen.

FWIW, my original patch (and driver) was an input driver, not a hid one.
I'm not sure either how the new driver got tested.


