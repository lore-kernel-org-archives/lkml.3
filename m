Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaCFK7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:59:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44697 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaCFK7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:59:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Thu, 06 Mar 2014 12:00:30 +0100
Message-ID: <6116451.L9roNDfSqL@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140306044529.GA6466@kroah.com>
References: <1391958577.25424.22.camel@x220> <2136780.FIdBGb725A@avalon> <20140306044529.GA6466@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 05 March 2014 20:45:29 Greg Kroah-Hartman wrote:
> On Thu, Mar 06, 2014 at 01:48:29AM +0100, Laurent Pinchart wrote:
> > On Wednesday 05 March 2014 16:28:03 Joe Perches wrote:
> > > On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:
> > > > Please note that -DDEBUG is equivalent to '#define DEBUG', not to
> > > > '#define CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to
> > > > have any effect.
> > > 
> > > Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
> > > dev_dbg statements are compiled in but not by default
> > > set to emit output.  Output can be enabled by using
> > > dynamic_debug controls like:
> > > 
> > > # echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control
> > > 
> > > See Documentation/dynamic-debug-howto.txt for more details.
> > 
> > Thank you for the additional information.
> > 
> > Would you recommend to drop driver-specific Kconfig options related to
> > debugging and use CONFIG_DYNAMIC_DEBUG instead ?
> 
> Yes, please do that, no one wants to rebuild drivers and subsystems with
> different options just for debugging.

Is CONFIG_DYNAMIC_DEBUG lean enough to be used on embedded systems ? Note that 
people would still have to rebuild their kernel to enable CONFIG_DYNAMIC_DEBUG 
anyway :-)

-- 
Regards,

Laurent Pinchart

