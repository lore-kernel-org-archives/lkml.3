Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaFCJth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:49:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41336 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbaFCJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:49:36 -0400
Date: Tue, 3 Jun 2014 10:49:32 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: core: Add the option to order destruction of
	MFD cells
Message-ID: <20140603094932.GF11951@opensource.wolfsonmicro.com>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140602210117.GO31751@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602210117.GO31751@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:01:17PM +0100, Mark Brown wrote:
> On Mon, Jun 02, 2014 at 10:01:43AM +0100, Charles Keepax wrote:
> > Sometimes MFD children will have interdependancies. For example an MFD
> > device might contain a regulator cell and another cell which requires
> > that regulator to function. Probe deferral will ensure that these
> > devices probe in the correct order, however currently nothing ensures
> > they are destroyed in the correct order. As such it is possible for a
> > cell to be destroyed whilst another cell still expects it to exist. For
> > example the cell mentioned earlier would attempt to do a regulator_put
> > as part of its own tear-down but the regulator may have already been
> > destroyed.
> 
> Probe deferral is supposed to handle removal too, we're supposed to be
> able to walk the device list in reverse order and everything just work.

I had considered this approach but was perhaps incorrectly too
nervous about it. I was slightly concerned about breaking other
MFD devices by changing the order things destroy in. Also the way
the child devices are iterated with device_for_each_child, there is
lack of helpers to process the klist in reverse and it felt like
code I probably shouldn't be modifying.

I am happy to do a version that removes devices in reverse probe
order, if that is preferrable? But any pointers if I am missing
the obvious way to do that would be appreciated.

Thanks,
Charles
