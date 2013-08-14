Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3HNNay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:30:54 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61658 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3HNNaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:30:52 -0400
Date: Wed, 14 Aug 2013 09:30:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write
 functions
Message-ID: <20130814133048.GC28628@htj.dyndns.org>
References: <5209892D.8070502@huawei.com>
 <52098941.4070600@huawei.com>
 <20130813150549.GF26596@mtj.dyndns.org>
 <520AE4FC.5090702@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520AE4FC.5090702@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Aug 14, 2013 at 10:01:32AM +0800, Li Zefan wrote:
> But most controllers don't check this in those read/write functions.
> It shoudn't do any harm not checking online/offline status.

It depends on the specific controller.  For controllers which make
clear distinction between online and offline states for, say,
hierarchical config propagation, it could lead to buggy behavior if
the function body afterwards assume that the current node is online.
I don't know whether this is the case for the functions converted here
but even if so the patch needs to update the description.

Thanks.

-- 
tejun
