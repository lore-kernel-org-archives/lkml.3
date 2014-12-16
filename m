Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaLPLfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:35:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42084 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaLPLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:35:47 -0500
Date: Tue, 16 Dec 2014 14:35:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Chris Rorvick <chris@rorvick.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        Greg Donald <gdonald@gmail.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not specified
Message-ID: <20141216113509.GI4856@mwanda>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
 <20141216094109.GH4856@mwanda>
 <D0B55F56.D05F1%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0B55F56.D05F1%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:14:35AM +0000, Dilger, Andreas wrote:
>
> Sorry, that isn't right.  Chris' patch is actually doing the right thing
> to check for units > 1.

It's not right because it discards the negative.


>  The proposed change above discards "mult"
> entirely, which breaks the users of this function that are not in this
> file (e.g. osc_cached_mb_seq_write() or ll_max_cached_mb_seq_write())
> that have tunables in units of MB by default, but can also use parameters
> with units like "4.5G" for convenience.

I think you are confusing lprocfs_write_frac_helper() and
lprocfs_write_frac_u64_helper().  There is only one caller for this
function.

! grep lprocfs_write_frac_u64_helper drivers/staging/lustre/ -R | grep -v smatch  | grep -v '\.i:'
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c:        return lprocfs_write_frac_u64_helper(buffer, count, val, 1);
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c:int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c:EXPORT_SYMBOL(lprocfs_write_frac_u64_helper);
drivers/staging/lustre/lustre/include/lprocfs_status.h:extern int lprocfs_write_frac_u64_helper(const char *buffer,

regards,
dan carpenter

