Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaLTMvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:51:09 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49012 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaLTMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:51:05 -0500
Date: Sat, 20 Dec 2014 12:50:20 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Reichel <sre@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] misc: add a driver to power on/off UART attached
 devices.
Message-ID: <20141220125020.49d0bba0@lxorguk.ukuu.org.uk>
In-Reply-To: <20141220000920.13943.50943.stgit@notabene.brown>
References: <20141219235827.13943.45713.stgit@notabene.brown>
	<20141220000920.13943.50943.stgit@notabene.brown>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 11:09:21 +1100
NeilBrown <neilb@suse.de> wrote:

> If a platform has a particular device permanently attached to a UART,
> there may be out-of-band signaling necessary to power the device
> on and off.
> 
> This drive controls that signalling for a number of different devices.
> It can
>  - enable/disable a regulator
>  - toggle a GPIO
>  - register an 'rfkill' which can for the device to be off.
> 
> When the rfkill is absent of unblocked, the device will be on when the
> associated tty device is open, and closed otherwise.
> 

Looks sound to me. Would drivers/tty/slave/.. be a better place for
these to collect up than "misc" ?

