Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3BKPIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:08:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3BKPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:08:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O routines
Date: Mon, 11 Feb 2013 15:08:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <201302111152.42483.arnd@arndb.de> <20130211125836.GN20996@sortiz-mobl>
In-Reply-To: <20130211125836.GN20996@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111508.24317.arnd@arndb.de>
X-Provags-ID: V02:K0:JylMCgbYgm5S3oIVspbhqBt7t4sJDU6TM8CaE81i5l8
 PFLsHRcbAXko+JU2snicUkT0UOkAuSiN1pRJ+D2agWEfHnKyOv
 A2ZX02USJNZF4+tP/p4jQvB1qOljoey3eTmMfrcaVgHo0zUdDe
 JT+WxGpCrUQsZszqcaFDXpS7dFiG7LD13eEQqnoERmUWJFiiVL
 3dprVQ0PYmbbV58A3EfkscR4RW4O4fOraSsBB9VnGQtrfGGvZO
 eSQuC1cdp7EB7a4ZvnYM4ErDnZs+rWPj47Yf1fqLmYY+eCIQBv
 rA6b/ML5sNjEZrt7TP/YugsIRVaYFFHL2iE1NLE8WSCCYlIh4p
 BQ8REqcaxzD/RrPU5/MI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Samuel Ortiz wrote:
> On Mon, Feb 11, 2013 at 11:52:42AM +0000, Arnd Bergmann wrote:
> > On Thursday 07 February 2013, Samuel Ortiz wrote:
> > > On Thu, Feb 07, 2013 at 10:34:44PM +0000, Arnd Bergmann wrote:
> > > > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > > > +
> > > > > +struct mei_bus_ops {
> > > > > +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > > +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > > +};
> > > > > +
> > > > 
> > > > Can you have more than one set of mei_bus_ops in a driver? 
> > > You can have at most one mei_bus_ops per mei_bus_client.
> > > 
> > > > If not, how about adding the callbacks to the mei_bus_driver structure
> > > > directly as a simplification? 
> > > I can add the ops directly to the mei_bus_client structure, yes.
> > 
> > I looked at the new version, and it's not what I assumed it would be.
> > I thought the operations were specific to a client driver and should
> > be part of the /mei_bus_driver/ structure, not the /mei_bus_client/.
> The ops should be part of mei_bus_client as they're specific to the MEI
> protocol for a given IP block on the ME. You need to have MEI and HECI
> knowledge to implement those ops and drivers (defining their mei_bus_driver
> structure) should not have that kind of knowledge but rather focus on the
> technology they're driving.
> If we take the NFC example again, the drivers/nfc/ code will send NFC payloads
> to the bus I/O routines and this is where the mei_bus_client ops will add the
> ME specific protocol (command and request id for the NFC block) on top of it.
> In practice, this is an additional header which handles a transport layer that's
> specific not only to the ME but to the NFC block of it. So each ME block can
> have its own protocol to send and receive technology specific payloads, that's
> what those ops implement.
> That's why I think that those ops should not be defined by the drivers/nfc/ code
> and in fact should be opaque to it.

I think I'm still confused. What I read in your description is that unlike
other subsystems that have a common bus implementation that is hooked into
by two kinds of drivers (bus drivers that provide devices like a USB host
controller, and device drivers that use those devices), you have three
components that can be mixed independently: the bus (based on which
PCI device you have), the transport and the endpoint device. Is that
correct?

If so, how do you know which transport to use?

	Arnd
