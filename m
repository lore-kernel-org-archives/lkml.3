Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaAOSaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:30:08 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:51155
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbaAOSaF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:30:05 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Thread-Topic: [PATCH v4] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Thread-Index: AQHPEYgM5Ap6kg243EyxOgeJRi0s75qFnnmAgAB7jCA=
Date: Wed, 15 Jan 2014 18:29:21 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817E79783@P3PWEX4MB008.ex4.secureserver.net>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com>
 <20140115035849.GA13127@kroah.com>
In-Reply-To: <20140115035849.GA13127@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 8:59 PM, Greg KH wrote:
> Sleep for at least 10, as I think that's the smallest time delay you can
> sleep for anyway (meaning it will be that long no matter what number you
> put there less than 10, depending on the hardware used of course.)

A bit off topic here but I have a somewhat related question about timeouts.

There are a number of comedi drivers that do a "wait for end-of-conversion"
as part of the (*insn_read) for an analog input subdevice or (*insn_write) for
an analog output subdevice. These functions return an errno if a timeout occurs.

Currently either -ETIME or -ETIMEDOUT is returned. This errno ends up getting
returned to the user as the result of the unlocked_ioctl file operation. What is
the more appropriate errno? Or is there is better one that should be used?

Regards,
Hartley
