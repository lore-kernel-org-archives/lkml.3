Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaCFBug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:50:36 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41966 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbaCFBuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:50:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Thu, 06 Mar 2014 02:52:03 +0100
Message-ID: <18589524.VtEDRg43uX@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394069742.12070.39.camel@joe-AO722>
References: <1391958577.25424.22.camel@x220> <3032500.9J1uSX3lel@avalon> <1394069742.12070.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wednesday 05 March 2014 17:35:42 Joe Perches wrote:
> On Thu, 2014-03-06 at 02:27 +0100, Laurent Pinchart wrote:
> > On Wednesday 05 March 2014 17:00:37 Joe Perches wrote:
> > > On Thu, 2014-03-06 at 01:48 +0100, Laurent Pinchart wrote:
> > > > Would you recommend to drop driver-specific Kconfig options related to
> > > > debugging and use CONFIG_DYNAMIC_DEBUG instead ?
> > > 
> > > For development, sure, if there's sufficient memory.
> > > For embedded systems with limited memory, using dynamic_debug isn't
> > > always possible or effective.
> > > Also, there are sometimes reasons to have debugging messages always
> > > enabled or emitted.
> > > For those cases, either adding #define DEBUG or using printk(KERN_DEBUG
> > > would be fine.
> > 
> > My goal here is to offer an easy way for users to enable debugging without
> > requiring changes to the source code.
> 
> Dynamic debugging works, but various distributions don't
> have it enabled.
> 
> > The driver includes various dev_dbg() messages, I don't want to ask people
> > reporting problems to turn them into printk() calls :-) Even adding
> > #define DEBUG at the beginning of the source files is likely too error
> > prone for users without much programming experience.
>
> I think your best bet is to add #define DEBUG to a common
> header file like iss.h or omap4iss.h

I've thought about that, but it would require iss.h to be included before all 
other headers. I've also thought about creating an iss-debug.h header to be 
included first just to #define DEBUG, but decided to go for handling the OMAP4 
ISS debug option in the Makefile instead. If that's ugly and discouraged as 
reported by Mauro I can try to come up with something else.

-- 
Regards,

Laurent Pinchart

