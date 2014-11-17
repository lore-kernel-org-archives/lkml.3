Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaKQWqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:46:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKQWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:46:34 -0500
Date: Tue, 18 Nov 2014 01:46:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Juston Li <juston.h.li@gmail.com>
Cc: oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: mdc: use __FMODE_EXEC macro
Message-ID: <20141117224616.GI4905@mwanda>
References: <1416263028-16026-1-git-send-email-juston.h.li@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416263028-16026-1-git-send-email-juston.h.li@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:23:48PM -0800, Juston Li wrote:
> FMODE_EXEC is type fmode_t but is used in operations
> with integers which leads to sparse warnings:
> drivers/staging/lustre/lustre/mdc/mdc_lib.c:198:21: warning: restricted fmode_t degrades to integer
> drivers/staging/lustre/lustre/mdc/mdc_locks.c:300:49: warning: restricted fmode_t degrades to integer
> 
> Fix by using __FMODE_EXEC macro defined in fs.h.
> 
> Note the same warnings occurs with other fmode flags
> here but they don't have a corresponding int macro.
> 

When are FMODE_EXEC and __FMODE_EXEC not defined?  I think they're
always defined.  I don't understand the point of these ifdefs.  I guess
maybe they are for compatability with obsolete kernels?

regards,
dan carpenter

