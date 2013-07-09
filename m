Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3GIOxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:53:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab3GIOxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:53:33 -0400
Date: Tue, 9 Jul 2013 09:53:21 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130709145321.GA1680@kahuna>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
 <1373290980-17883-3-git-send-email-sourav.poddar@ti.com>
 <20130708203330.GA28322@kahuna>
 <20130709065143.GC5552@arwen.pp.htv.fi>
 <51DC072F.40704@ti.com>
 <20130709144043.GV27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130709144043.GV27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:40-20130709, Mark Brown wrote:
> On Tue, Jul 09, 2013 at 07:50:55AM -0500, Nishanth Menon wrote:
> 
> > with this input and looking closer, I think I see what you are saying now:
> > dra7xxx_qspi_prepare_xfer -> does a pm_runtime_get_sync
> > dra7xxx_qspi_unprepare_xfer -> does a pm_runtime_mark_last_busy,
> > pm_runtime_put_autosuspend
> 
> > In between these calls, you have the remaining xfer calls going on.
> > we are assuming here that autosuspend timeout should be greater than
> > the time to complete the worst case transfer.
> 
> No, autosuspend will do nothing so long as there are references to the
> device held.  The effect of autosuspend is to delay power down after the
> last reference has been dropped, otherwise things run normally.

Thanks on the clarification. That concludes my confusion on the topic
:).

-- 
Regards,
Nishanth Menon
