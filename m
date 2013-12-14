Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3LNLUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 06:20:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LNLUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 06:20:52 -0500
Message-ID: <52AC3EF1.6090106@oracle.com>
Date: Sat, 14 Dec 2013 19:20:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <zwu.kernel@gmail.com>
CC: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: factor prid related codes into xfs_get_initial_prid()
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com> <1386944873-16796-2-git-send-email-zwu.kernel@gmail.com> <20131213163211.GD20803@infradead.org>
In-Reply-To: <20131213163211.GD20803@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14 2013 00:32 AM, Christoph Hellwig wrote:
>> +static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
>> +{
>> +	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>> +		return xfs_get_projid(dp);
>> +	else
>> +		return XFS_PROJID_DEFAULT;
>> +}
> 
> You could skip the else here.
Except that, I'd suggest we move this helper to proper header file with
further refactoring in xfs_symlink(), and it could be a separate patch.

Thanks,
-Jeff
