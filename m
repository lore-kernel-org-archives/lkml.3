Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaCFEpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:45:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaCFEpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:45:03 -0500
Date: Wed, 5 Mar 2014 20:45:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Message-ID: <20140306044529.GA6466@kroah.com>
References: <1391958577.25424.22.camel@x220>
 <3099833.ZhlQFyxhbo@avalon>
 <1394065683.12070.32.camel@joe-AO722>
 <2136780.FIdBGb725A@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2136780.FIdBGb725A@avalon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:48:29AM +0100, Laurent Pinchart wrote:
> Hi Joe,
> 
> On Wednesday 05 March 2014 16:28:03 Joe Perches wrote:
> > On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:
> > > Please note that -DDEBUG is equivalent to '#define DEBUG', not to '#define
> > > CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to have any
> > > effect.
> >
> > Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
> > dev_dbg statements are compiled in but not by default
> > set to emit output.  Output can be enabled by using
> > dynamic_debug controls like:
> > 
> > # echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control
> > 
> > See Documentation/dynamic-debug-howto.txt for more details.
> 
> Thank you for the additional information.
> 
> Would you recommend to drop driver-specific Kconfig options related to 
> debugging and use CONFIG_DYNAMIC_DEBUG instead ?

Yes, please do that, no one wants to rebuild drivers and subsystems with
different options just for debugging.

thanks,

greg k-h
