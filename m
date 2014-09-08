Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaIHJWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:22:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:41614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaIHJWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="587857408"
Date: Mon, 8 Sep 2014 17:22:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [dummy-irq] genirq: Flags mismatch irq 0. 00000080 (dummy_irq)
 vs. 00015a20 (timer)
Message-ID: <20140908092228.GA24801@localhost>
References: <20140908091248.GA23776@localhost>
 <alpine.LNX.2.00.1409081114290.5523@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1409081114290.5523@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:15:37AM +0200, Jiri Kosina wrote:
> On Mon, 8 Sep 2014, Fengguang Wu wrote:
> 
> > This patch is found to trigger a call trace dump during kernel boot.
> > Can it be possibly fixed? Thanks!
> 
> Hi Fengguang,
> 
> from the dmesg it's obvious that dummy-irq is requesting IRQ#0 by default. 
> This has been fixed back in 2013 via commit a7b594b490. Are you sure you 
> have that commit applied?

Ah yes! Sorry I looked at the wrong line of the table.. it becomes
obvious when listing the dummy_irq line alone: it no longer shows up
in next-20140905.

+------------------------------------------------------+------------+------------+---------------+
|                                                      | 4c6e22b8a9 | 54f69b92f0 | next-20140905 |
+------------------------------------------------------+------------+------------+---------------+

| genirq:Flags_mismatch_irq.(dummy_irq)vs.(timer)      | 0          | 20         |               |
