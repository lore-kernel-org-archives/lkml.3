Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaLPJlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:41:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaLPJlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:41:36 -0500
Date: Tue, 16 Dec 2014 12:41:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Rorvick <chris@rorvick.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org, Greg Donald <gdonald@gmail.com>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not specified
Message-ID: <20141216094109.GH4856@mwanda>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418708509-18196-1-git-send-email-chris@rorvick.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:41:49PM -0600, Chris Rorvick wrote:
> Units can be passed to lprocfs_write_frac_u64_helper() via a suffix
> (e.g., "...K", "...M", etc.) tacked onto the value.  A comment states
> that "specified units override the multiplier," though the multiplier is
> overridden regardless.  Update the conditional logic so that it only
> applies when units are specified.
> 

That introduces a bug.  We need to take the initial '-' into
consideration.  Just remove the condition.  Also remove the "mult"
parameter since that is always 1.

	bool negative = false;

	...

	if (*pbuf == '-') {
		negative = true;
		pbuf++;
	}

	...

	mult = negative ? -units : units;


regards,
dan carpenter

