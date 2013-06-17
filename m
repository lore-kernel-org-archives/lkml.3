Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3FQITf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:19:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:7765 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FQITb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,879,1363158000"; 
   d="scan'208";a="318118225"
Date: Mon, 17 Jun 2013 11:23:31 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
Message-ID: <20130617082331.GG11878@intel.com>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
 <20130610152954.GE2987@katana>
 <20130612144743.GB8102@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130612144743.GB8102@ab42.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:47:45PM +0200, Christian Ruppert wrote:
> On Mon, Jun 10, 2013 at 05:29:55PM +0200, Wolfram Sang wrote:
> > On Tue, May 14, 2013 at 03:04:02PM +0200, Christian Ruppert wrote:
> > > This patch makes the SDA hold time configurable through device tree.
> > > 
> > > [rebased to i2c-current/i2c-next/mainline-3.10-rc1]
> > > 
> > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> > 
> > Hmm, I really have problems adding a generic property. I need to better
> > understand why this is needed? What is the usecase? Can't a safe value
> > be calculated depending on the bus-speed? Is there a public datasheet
> > available somewhere?
> 
> I checked with our PCB/Applications team and the data sheets for the
> peripherals in question (DVB demodulator front ends) are under NDA.
> Mika, you seem to be interested in this patch as well. Do you know of
> any publicly available data sheets for hardware requiring this
> adjustment?

Sorry for the delay, I was on vacation.

I'm not aware of any publicly available datasheets for this block,
unfortunately.

> In the case of the Designware block, the parameter both changes SDA and
> START hold times, however, and you'll find lots of data sheets for
> hardware with START hold time requirements on the net, e.g.
> http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf
> 
> The empirical solution in the function i2c_dw_scl_hcnt does not seem to
> work in all cases: Our lab guys confirmed that we have several PCB
> designs which do not work without adjusting the sda-hold-time parameter
> to an appropriate value. The value seems to be different for different
> PCBs.

Yeah, we see the same problem. Our platform guys have solved this so that
they made the SDA hold time available from ACPI to the device driver.

> I suspect that this kind of configurability is not the same for all i2c
> bus master hardware. If you don't want to add a generic property, would
> you accept the patch with the property renamed to dwi2c,sda-hold-time?
> 
> Greetings,
>   Christian
> 
> 
> -- 
>   Christian Ruppert              ,          <christian.ruppert@abilis.com>
>                                 /|
>   Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
>                              _// | bilis Systems   CH-1228 Plan-les-Ouates


