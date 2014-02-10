Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBJPN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:13:56 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:52676 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaBJPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:13:54 -0500
Message-ID: <1392045231.3585.33.camel@x220>
Subject: Re: [PATCH] [media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 16:13:51 +0100
In-Reply-To: <3300576.MqDnfacnEA@avalon>
References: <1391958577.25424.22.camel@x220> <3300576.MqDnfacnEA@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 15:13:52.0207 (UTC) FILETIME=[B5038DF0:01CF2672]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent,

On Mon, 2014-02-10 at 15:13 +0100, Laurent Pinchart wrote:
> On Sunday 09 February 2014 16:09:37 Paul Bolle wrote:
> > Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> > camera interface - Build system") added a Kconfig entry for
> > VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> > 
> > This entry was apparently copied from a similar entry for "OMAP 3
> > Camera debug messages". But a corresponding Makefile line is missing.
> > Besides, the debug code also depends on a mysterious ISS_ISR_DEBUG
> > macro. This Kconfig entry can be removed.
> 
> What about adding the associated Makefile line instead to #define DEBUG when 
> VIDEO_OMAP4_DEBUG is selected, as with the OMAP3 ISP driver ?
>  
> > Someone familiar with the code might be able to say what to do with the
> > code depending on the DEBUG and ISS_ISR_DEBUG macros.
> 
> ISS_ISR_DEBUG is expected to be set by manually modifying the source code, as 
> it prints lots of messages in interrupt context.

Which renders the DEBUG macro pointless. Or does the code use some
dev_dbg()-like magic, which is only triggered if the DEBUG macro is set?

Thanks,


Paul Bolle

