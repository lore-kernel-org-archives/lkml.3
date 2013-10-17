Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595Ab3JQTP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:15:29 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:52014 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762432Ab3JQTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:15:25 -0400
Date: Thu, 17 Oct 2013 19:15:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page to
 reduce memory usage
In-Reply-To: <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
Message-ID: <00000141c7d7ff58-44f388c4-da4a-4438-84a3-a2edb161b6a4-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Andrew Morton wrote:

> This issue hasn't been well thought through.  Given a random struct
> page, there isn't any protocol to determine what it actually *is*.
> It's a plain old variant record, but it lacks the agreed-upon tag field
> which tells users which variant is currently in use.

This issue has bitten us when SLUB was first introduced. We found out the
hard way f.e. that the mapping field had meaning in various contexts for a
slab page.

