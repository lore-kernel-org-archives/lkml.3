Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbbAWKhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:37:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29651 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbbAWKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:37:52 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-96-54c2247dbf52
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1421971730-17024-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1421971730-17024-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: trigger correct checkpoint during
	umount
Date: Fri, 23 Jan 2015 18:37:04 +0800
Message-id: <000401d036f8$a3530260$e9f90720$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFaMPpnZeb37MLacFcfPEJmggOwHZ25eDtQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd1alUMhBnNWqVk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXHoRxtLwXq2ivM3
	lrI1MC5i7WLk5JAQMJGY8eU+I4QtJnHh3nq2LkYuDiGB6YwSWz58Y4RwfjBKzLt/lg2kik1A
	RWJ5x38mkISIQC+jxI8z/cwgCSEBJ4lz+yayg9icAs4SPyesYQKxhQVCJHYevQgWZxFQldh0
	5iYLiM0rYCkx7e4SVghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvGWGOE9BYsfZ12CniggYSXyf
	2MIGUSMusfHILZYJjIKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOMifSe9gXNVgcYhRgINRiYe3YcvBECHWxLLiytxDjBIczEoivHFfgEK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5lezbQoQE0hNLUrNTUwtSi2CyTBycUg2M87Y7HNuS0RN4eJ7kAr/7+aL+
	tSqdHbOaHq4w+XtF9caZVa1PL7vO05Yp5dfSWGh2yDVAR+OQ0KQd664U3Zmm4Ppyzl6GwhbX
	j3tNIlS/Bd46bVV/3OdJofncPT53px23X2X6Pu3YNqNPF7fH2+1tudn+kd/psl2dhte30r/1
	Pz1Mz59eoRVxQYmlOCPRUIu5qDgRAE85k99uAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, January 23, 2015 8:09 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/2] f2fs: trigger correct checkpoint during umount
> 
> This patch fixes to trigger checkpoint with umount flag when kill_sb was called.
> In kill_sb, f2fs_sync_fs was finally called, but at this time, f2fs can't do
> checkpoint with CP_UMOUNT.
> After then, f2fs_put_super is not doing checkpoint, since it is not dirty.
> 
> So, this patch adds a flag to indicate f2fs_sync_fs is called during umount.

Nice catch!

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>


