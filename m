Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaCaLe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:34:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:54403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaCaLeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:34:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,764,1389772800"; 
   d="scan'208";a="503457467"
Date: Mon, 31 Mar 2014 19:34:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [mtd/sbc_gxx] kernel BUG at include/linux/mtd/map.h:148!
Message-ID: <20140331113412.GA13548@localhost>
References: <20140327140140.GA9083@localhost>
 <CAErSpo7b+OJUoRcMY0edZPgEKG6DbwdLcq5M0-9B6JKALpm+QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7b+OJUoRcMY0edZPgEKG6DbwdLcq5M0-9B6JKALpm+QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Michal and kbuild list.

On Thu, Mar 27, 2014 at 04:51:53PM -0600, Bjorn Helgaas wrote:
> [+cc David, Brian]
> 
> On Thu, Mar 27, 2014 at 8:01 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > FYI, here is a very old warning, too old to be bisected.
> >
> > [    5.282127] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> > [    5.286079] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> > [    5.288723] ------------[ cut here ]------------
> > [    5.289649] kernel BUG at include/linux/mtd/map.h:148!
> 
> I think the problem is that your randconfig happens to have none of
> CONFIG_MTD_MAP_BANK_WIDTH_* set (you should have played the lottery
> today!), and the default implementation of map_bankwidth() in that
> case is just "BUG()":
> 
>   $ grep MTD_MAP config-3.14.0-rc8-wl-03045-gdf16ea4
>   # CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
>   # CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
>   # CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
>   # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
>   # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
>   # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> 
> I don't know enough Kconfig or MTD to fix this.

Michal, the problem we run into is, how to select one of the above
CONFIG_MTD_MAP_BANK_WIDTH_xx in "make randconfig".

Thanks,
Fengguang
