Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3BKLuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:50:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:50:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 01/11 V2] mei: bus: Initial MEI bus type implementation
Date: Mon, 11 Feb 2013 11:50:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com> <20130208235341.GA24127@kroah.com> <20130210032555.GG20996@sortiz-mobl>
In-Reply-To: <20130210032555.GG20996@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111150.26785.arnd@arndb.de>
X-Provags-ID: V02:K0:BBuKSYaFbTZS5UITAJLeCLQWM1lSKIaJe1Ccc7N7k9k
 DxNI8FwnhCoPFpTEI8ms5ftrw2j7hLaoY/jMRoZs7rYXDvl/5O
 D6K7tah6thu3od+wO0Fsk2XN1N4xGAeL5dzr3ax2Rhcn1uUk10
 yXJxwStUN9HBUrEKK7GP6G0+9YDQkNDxdakwvEehYl2iN0jpmW
 fvUccG53E7ETElXbYltcNrZQT+a/R0iaZ6ysFQBiPmKzP5kMNi
 ZnTPJKy9C/Kx0vy88EcqNkHKb9Ug5lng+sS7vshhhWyzHZEfrq
 i7eM8dhTY1IrDagmORKOH+HecxuGhn4PeMS5groL7m6zqhIWVI
 yQ53xBpZhHmebWNfUjnM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2013, Samuel Ortiz wrote:
> > >  
> > >  /**
> > > + * mei_bus_client
> > 
> > I don't really understand this structure, please explain it better.
> This is a structure that links the MEI bus client pointer passed to the driver
> with the actual ME client. It also allows the ME driver to implement
> technology specific ME protocol through the send/recv hooks.

I think part of the confusion is that this is what in other subsystems
is called a device, not a client. I believe I'm still confused in the
same way that Greg is.

You already have a 'struct mei_device', which refers to the PCI device
that owns the bus, and has clients attached to it. While it may be
a little confusing to people that already worked with the current
mei code, I think it would help to rename the existing 'mei_device'
to 'mei_host' or something else that feels appropriate, and introduce
the new structure as 'mei_device' derived from 'struct device', again
matching what most other subsystems do.

Similarly, you can then rename 'mei_bus_driver' to 'mei_driver' to fit
that logic, since I would consider a 'bus_driver' to be something
that is responsible for the entire bus, not just for one device.

	Arnd
