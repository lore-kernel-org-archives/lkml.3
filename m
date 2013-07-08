Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3GHErv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 00:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:21752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3GHEru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1016,1363158000"; 
   d="scan'208";a="361802815"
Date: Mon, 8 Jul 2013 12:47:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Jim Garlick <garlick@llnl.gov>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v9fs:for-linus 7/7] ERROR: code indent should use tabs where
 possible
Message-ID: <20130708044747.GA23911@localhost>
References: <51d9c6c4.k6qhnvy45dNR8Ghq%fengguang.wu@intel.com>
 <20130708004233.GA8958@localhost>
 <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
 <20130708033004.GA20091@localhost>
 <1373255644.1893.3.camel@joe-AO722>
 <20130708044542.GE20091@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708044542.GE20091@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > TRAILING_STATEMENTS
> > 
> > False positives?  Got an example?
> 
> tree:   git://git.freedesktop.org/git/nouveau/linux-2.6 drm-nouveau-next
> head:   d2989b534ef6834ebf2425aecc040b894b567c91
> commit: 01672ef454307bf63e93defb3599399b678ff58b [3/68] drm/nve0/fifo: copy engine context stored in ramfc, not externally
> 
> ERROR: trailing statements should be on next line
> #28: FILE: drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c:146:
> +       case NVDEV_ENGINE_GR   : addr = 0x0210; break;
> 
> ERROR: trailing statements should be on next line
> #40: FILE: drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c:183:
> +       case NVDEV_ENGINE_COPY2: addr = 0x0000; break;
> 
> ERROR: trailing statements should be on next line
> #41: FILE: drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c:184:
> +       case NVDEV_ENGINE_GR   : addr = 0x0210; break;

In this case the code does look neat:

        switch (nv_engidx(object->engine)) {
        case NVDEV_ENGINE_SW   : return 0;
-       case NVDEV_ENGINE_GR   :
        case NVDEV_ENGINE_COPY0:
-       case NVDEV_ENGINE_COPY1: addr = 0x0210; break;
+       case NVDEV_ENGINE_COPY1:
+       case NVDEV_ENGINE_COPY2: addr = 0x0000; break;
+       case NVDEV_ENGINE_GR   : addr = 0x0210; break;
        case NVDEV_ENGINE_BSP  : addr = 0x0270; break;
        case NVDEV_ENGINE_VP   : addr = 0x0250; break;
        case NVDEV_ENGINE_PPP  : addr = 0x0260; break;

Thanks,
Fengguang
