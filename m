Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3IJVGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:06:44 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:33258 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab3IJVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:06:42 -0400
Date: Tue, 10 Sep 2013 21:06:40 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Li Zefan <lizefan@huawei.com>
cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] slub: Fix calculation of cpu slabs
In-Reply-To: <522E9569.9060104@huawei.com>
Message-ID: <0000014109b29246-61170b4a-7ab7-41f0-a887-a1cd62603196-000000@email.amazonses.com>
References: <522E9569.9060104@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.10-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Li Zefan wrote:

> We should use page->pages instead of page->pobjects when calculating
> the number of cpu partial slabs. This also fixes the mapping of slabs
> and nodes.

True.

> As there's no variable storing the number of total/active objects in
> cpu partial slabs, and we don't have user interfaces requiring those
> statistics, I just add WARN_ON for those cases.


Well that is not strictly required but it does not hurt either.

Acked-by: Christoph Lameter <cl@linux.com>
