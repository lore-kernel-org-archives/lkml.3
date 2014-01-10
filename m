Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaAJQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:16:58 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:46513 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbaAJQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:16:55 -0500
Date: Fri, 10 Jan 2014 18:16:10 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH v4] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20140110161608.GA23774@chokladfabriken.org>
References: <1385739911-6541-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <52CFE2BB.8090004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFE2BB.8090004@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 02:08:27PM +0200, Tomi Valkeinen wrote:
> Hi,
> 
> On 2013-11-29 17:45, Stefan Kristiansson wrote:
> > This adds support for the VGA/LCD core available from OpenCores:
> > http://opencores.org/project,vga_lcd
> > 
> > The driver have been tested together with both OpenRISC and
> > ARM (socfpga) processors.
> > 
> > Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> 
> If I'm not mistaken, this driver has been designed so that there can
> only be one VGA/LCD core device on the system.
> 
> It would be better to get rid of those static structs, and have the
> driver data per device as it should. That way the driver works even with
> multiple VGA/LCD cores (although the video mode module option is a bit
> odd in that case).
> 

You're right, it's a completely realistic scenario with several
VGA/LCD cores in the system, so the one device only restriction is bad.
And looking closer at the static structs, I see that the ocfb_var and ocfb_fix
doesn't surve any purpose at all, so they can just be removed.
And the information in ocfb_par can easily be obtained directly from ocfb_dev
instead, so by setting info.par to point at that, the ocfb_par struct can also
be removed completely.
Thanks, that suggestion makes the implementation cleaner as well.

I'll post an updated patch with the changes.

Stefan
