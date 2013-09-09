Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3IIS1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:27:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:50188 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3IIS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:26:59 -0400
Message-ID: <1378744818.1381.4.camel@linux-fkkt.site>
Subject: Re: Doubts on IO requests in USB subsystem
From: Oliver Neukum <oliver@neukum.org>
To: "Morales, Alejandra" <alejandra.morales@tum.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Sep 2013 18:40:18 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.9.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 08:20 +0000, Morales, Alejandra wrote:
> mounted and there is no application using them at the moment, so that
> I was expecting that none
> of them receive file system requests. Indeed the SATA HD does not
> receive any requests unless I
> mount or unmount it, but the USB HD receives a large number of file
> system requests and it seems
> that it never enters into an idle state. Since any application is
> using it I think these requests may
> come from the USB subsystem. Am I right? If so, how could I determine
> whether a request comes
> from the USB subsystem or it is a file system request that actually
> moves blocks?

Your prime suspect is the detection of medium change which was
moved into the kernel in 3.2 or so. It can be disabled by sysfs.
Generally the notion that a certain task originates a read or write
on a block device is iffy. Read-ahead and shared data structures
make it impossible to accurately tell.

USB storage devices are notorious for setting the removable bit
even if they have no removable medium.

	Regards
		Oliver


