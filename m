Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3H3Ml0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:41:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:5083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab3H3MlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:41:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,990,1367996400"; 
   d="scan'208";a="388819068"
Date: Fri, 30 Aug 2013 15:41:19 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 0/2] vgaarb: Fixes for partial VGA opt-out
Message-ID: <20130830124119.GH11428@intel.com>
References: <20130815222835.27642.15330.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130815222835.27642.15330.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 04:37:47PM -0600, Alex Williamson wrote:
> I'm trying to add support for VGA arbitration on newer Intel graphics
> devices.  The existing code attempts to do this, but appear to have
> not been updated since GMCH devices roamed the Earth.  On newer
> devices like Haswell, we can disable VGA memory through an MSR on the
> device, but we rely on the VGA arbiter to manage VGA IO using the PCI
> COMMAND register.  In trying to unregister legacy VGA memory, I found
> that the VGA arbiter still wanted to disable both memory and IO on
> the device and that it forgot to actually program the device to
> disable IO when the decoding is updated.  This series attempts to fix
> both of those.  Thanks,

The series looks good to me.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       vgaarb: Don't disable resources that are not owned
>       vgaarb: Fix VGA decodes changes
> 
> 
>  drivers/gpu/vga/vgaarb.c |   50 ++++++++++++++++++++--------------------------
>  1 file changed, 22 insertions(+), 28 deletions(-)

-- 
Ville Syrjälä
Intel OTC
