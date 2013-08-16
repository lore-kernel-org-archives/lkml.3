Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3HPWwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:52:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3HPWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:52:39 -0400
Message-ID: <520E8C7E.90802@infradead.org>
Date: Fri, 16 Aug 2013 13:33:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <tao.peng@emc.com>, hpdd-discuss <hpdd-discuss@ml01.01.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: Tree for Aug 16 (lustre)
References: <20130816171634.8cb22a8f67d6dce8669d9899@canb.auug.org.au>
In-Reply-To: <20130816171634.8cb22a8f67d6dce8669d9899@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 00:16, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130815:
> 

lustre needs to depend on PROC_FS or provide stub functions for when
CONFIG_PROC_FS is not enabled, otherwise there are build errors and
warnings:


drivers/staging/lustre/lustre/lmv/lproc_lmv.c: In function 'lprocfs_lmv_init_vars':
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:232:26: error: 'lprocfs_lmv_module_vars' undeclared (first use in this function)
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:232:26: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:233:26: error: 'lprocfs_lmv_obd_vars' undeclared (first use in this function)
drivers/staging/lustre/lustre/lmv/lproc_lmv.c: At top level:
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:45:28: warning: 'lprocfs_module_vars' defined but not used [-Wunused-variable]
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:46:28: warning: 'lprocfs_obd_vars' defined but not used [-Wunused-variable]




-- 
~Randy
