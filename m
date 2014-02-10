Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaBJP2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:28:31 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:40092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:28:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG
Date: Mon, 10 Feb 2014 16:29:31 +0100
Message-ID: <1409428.L7JLLEda5C@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392045231.3585.33.camel@x220>
References: <1391958577.25424.22.camel@x220> <3300576.MqDnfacnEA@avalon> <1392045231.3585.33.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Monday 10 February 2014 16:13:51 Paul Bolle wrote:
> On Mon, 2014-02-10 at 15:13 +0100, Laurent Pinchart wrote:
> > On Sunday 09 February 2014 16:09:37 Paul Bolle wrote:
> > > Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> > > camera interface - Build system") added a Kconfig entry for
> > > VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> > > 
> > > This entry was apparently copied from a similar entry for "OMAP 3
> > > Camera debug messages". But a corresponding Makefile line is missing.
> > > Besides, the debug code also depends on a mysterious ISS_ISR_DEBUG
> > > macro. This Kconfig entry can be removed.
> > 
> > What about adding the associated Makefile line instead to #define DEBUG
> > when VIDEO_OMAP4_DEBUG is selected, as with the OMAP3 ISP driver ?
> > 
> > > Someone familiar with the code might be able to say what to do with the
> > > code depending on the DEBUG and ISS_ISR_DEBUG macros.
> > 
> > ISS_ISR_DEBUG is expected to be set by manually modifying the source code,
> > as it prints lots of messages in interrupt context.
> 
> Which renders the DEBUG macro pointless. Or does the code use some
> dev_dbg()-like magic, which is only triggered if the DEBUG macro is set?

Yes, dev_dbg() is used.

-- 
Regards,

Laurent Pinchart

