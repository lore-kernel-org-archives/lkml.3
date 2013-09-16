Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3IPLGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:06:42 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:46940 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3IPLGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:06:41 -0400
Message-ID: <1379329599.15916.25.camel@linux-fkkt.site>
Subject: Re: Doubts on IO requests in USB subsystem
From: Oliver Neukum <oliver@neukum.org>
To: "Morales, Alejandra" <alejandra.morales@tum.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 13:06:39 +0200
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE18E667@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>
	 ,<1378744818.1381.4.camel@linux-fkkt.site>
	 <9E3F9C2076C45D4783F09B90D5BE77CE18E667@BADWLRZ-SWMBX13.ads.mwn.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 10:33 +0000, Morales, Alejandra wrote:
> 2013/9/9 Oliver Neukum <oliver@neukum.org>
> >
> > Your prime suspect is the detection of medium change which was
> > moved into the kernel in 3.2 or so. It can be disabled by sysfs.
> > Generally the notion that a certain task originates a read or write
> > on a block device is iffy. Read-ahead and shared data structures
> > make it impossible to accurately tell.
> >
> > USB storage devices are notorious for setting the removable bit
> > even if they have no removable medium.
> >
> 
> Thanks for the answer Oliver. Unfortunately it doesn't seem to be the
> medium change detection what is causing these requests, since the
> removable bit is disabled and the polling period is set to -1:

Interesting. Then you have no choice. Make a usbmon trace and look
at the SCSI commands going to the device.

	HTH
		Oliver


