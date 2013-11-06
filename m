Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3KFL5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:57:54 -0500
Received: from postout2.mail.lrz.de ([129.187.255.138]:56523 "EHLO
	postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3KFL5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:57:51 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 06:57:51 EST
From: "Morales, Alejandra" <alejandra.morales@tum.de>
To: Oliver Neukum <oliver@neukum.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Doubts on IO requests in USB subsystem
Thread-Topic: Doubts on IO requests in USB subsystem
Thread-Index: Ac6tNIxdeqg8/IyVTFGPG7NXqAfNbwANfR4AAVc9W4L//+kugIAOP1KP
Date: Wed, 6 Nov 2013 11:51:33 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE195E6F@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>
	 ,<1378744818.1381.4.camel@linux-fkkt.site>
	 <9E3F9C2076C45D4783F09B90D5BE77CE18E667@BADWLRZ-SWMBX13.ads.mwn.de>,<1379329599.15916.25.camel@linux-fkkt.site>
In-Reply-To: <1379329599.15916.25.camel@linux-fkkt.site>
Accept-Language: en-US, es-ES
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4ca0:2001:40:224:e8ff:fe49:16b9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/16 Oliver Neukum <oliver@neukum.org>
> On Mon, 2013-09-16 at 10:33 +0000, Morales, Alejandra wrote:
> > 2013/9/9 Oliver Neukum <oliver@neukum.org>
> > >
> > > Your prime suspect is the detection of medium change which was
> > > moved into the kernel in 3.2 or so. It can be disabled by sysfs.
> > > Generally the notion that a certain task originates a read or write
> > > on a block device is iffy. Read-ahead and shared data structures
> > > make it impossible to accurately tell.
> > >
> > > USB storage devices are notorious for setting the removable bit
> > > even if they have no removable medium.
> > >
> >
> > Thanks for the answer Oliver. Unfortunately it doesn't seem to be the
> > medium change detection what is causing these requests, since the
> > removable bit is disabled and the polling period is set to -1:

> Interesting. Then you have no choice. Make a usbmon trace and look
> at the SCSI commands going to the device.

I made the usbmon and I could see a lot of scsi write commands, but no
clue about where they were coming from.

I did some testing on different computers and Linux distributions and
it turned out that those requests were issued only on a desktop running
Ubuntu. I followed this example:

http://ubuntuforums.org/showthread.php?t=833301

and I could figure out that the requests were coming from a daemon
called spindownd. After stopping it, they disappeared.

Thanks for you help, Oliver.

Regards,
Alejandra
