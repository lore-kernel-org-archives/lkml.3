Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3IKLJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:09:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab3IKLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:09:31 -0400
Date: Wed, 11 Sep 2013 12:09:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 3/5] FS: Export poll_select_copy_remaining and rename
 poll_select_copy_remaining in compat.c so it does not pick the wrong copy.
Message-ID: <20130911110901.GD26777@darko.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
 <1378762380-13152-3-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378762380-13152-3-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:32:57PM +0100, Andrew Pinski wrote:
>   The ILP32 ABI in ARM64 uses a slightly different pselect from either
>   the compat or even the native LP64 ABI.  We would want to reuse some
>   of the code path that are used as the size of the timespec is the
>   same, so this patch exports poll_select_copy_remaining from
>   fs/select.c and renames the copy in fs/compat.c to make sure that it
>   is not being used.
> 
> Signed-off-by: Andrew Pinski <apinski@cavium.com>

I think this patch has to wait until we review the ILP32 ABI for arm64.
When I looked at this some time ago I thought we can just use the native
arm64 pselect6 and ppoll. Once we agree that's not possible we can push
this patch. On its own it doesn't have much value.

-- 
Catalin
