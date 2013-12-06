Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3LFTCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:02:02 -0500
Received: from alt-proxy2.mail.unifiedlayer.com ([74.220.193.158]:32946 "HELO
	alt-proxy2.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756869Ab3LFTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:02:00 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 14:02:00 EST
Date: Fri, 6 Dec 2013 10:56:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Regression: hang on BYT with new pstate support
Message-ID: <20131206105656.4c4b1e5e@jbarnes-desktop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drm-intel tree just updated to 3.13-rc, and I started seeing early
hard hangs on my BYT system.  I bisected it down to this commit:

commit 19e77c28dbf1972305da0dfeb92a62f83df3a91d
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Mon Oct 21 09:20:35 2013 -0700

    intel_pstate: Add Baytrail support
    
    Add support for the Baytrail processor.

The hangs occur at different times, so unless the get/set functions
aren't called until we change the state, the problem may be in the
core_set_pstate function instead?  Maybe it's not suited to BYT somehow?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
