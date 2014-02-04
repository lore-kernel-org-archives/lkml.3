Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaBDIVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:21:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBDIVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:21:16 -0500
Date: Tue, 4 Feb 2014 11:21:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SeongJae Park <sj38.park@gmail.com>
Cc: gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: fix pointer-integer size mismatch warnings
Message-ID: <20140204082110.GG26722@mwanda>
References: <1391497163-6894-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391497163-6894-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:59:23PM +0900, SeongJae Park wrote:
> Fix the pointer-integer size mismatch warnings below:
> 	drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
> 	drivers/staging/bcm/CmHost.c:1387:39: warning: cast to pointer from
> 			integer of different size [-Wint-to-pointer-cast]
> 	  pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
> 					       ^
> 	drivers/staging/bcm/CmHost.c:1426:37: warning: cast to pointer from
> 			integer of different size [-Wint-to-pointer-cast]
> 	  pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
> 					     ^
> 	drivers/staging/bcm/CmHost.c:1440:35: warning: cast to pointer from
> 			integer of different size [-Wint-to-pointer-cast]
> 	  pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfActiveSet);
> 					   ^

No.  You haven't fixed the bug, you've just silenced the warning so now
someone has to spent hours and hours looking for it when it comes time
to write a proper fix.  Don't do that.

regards,
dan carpenter


