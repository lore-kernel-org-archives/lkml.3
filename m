Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaLVSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:50:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:11951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaLVSt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:49:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,625,1413270000"; 
   d="scan'208";a="651774960"
Date: Mon, 22 Dec 2014 10:49:40 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Oded Gabbay <oded.gabbay@amd.com>, Dana Elifaz <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>,
        rusty@rustcorp.co.au
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit
 kernel
Message-ID: <20141222184940.GB17192@tassilo.jf.intel.com>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
 <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:58:43AM -0500, Alex Deucher wrote:
> On Mon, Dec 22, 2014 at 6:11 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> > amdkfd driver can be compiled only in 64-bit kernel. Therefore, there is no
> > point in trying to initialize amdkfd in 32-bit kernel.
> >
> > In addition, in case of specific configuration of 32-bit kernel, no modules and
> > random kernel base, the symbol_request function doesn't work as expected - It
> > doesn't return NULL if the symbol doesn't exists. That makes the kernel panic.
> > Therefore, the as amdkfd doesn't compile in 32-bit kernel, the best way is just
> > to return false immediately.
> >
> > Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> 
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Sorry but the patch is just bogus. X-bit only code is usually
a very bad sign for the code. This is not windows programing after all.

Even if you wanted to do a 64bit only driver -- which
you probably don't -- the standard way would be to exclude
it in Kconfig.

Please root-cause why symbol_request doesn't work on 32bit
and fix it properly.

+rusty.

-Andi

