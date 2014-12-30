Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaL3Gpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 01:45:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:39215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaL3Gpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 01:45:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,664,1413270000"; 
   d="scan'208";a="654786342"
From: Andi Kleen <andi@firstfloor.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
Date: Mon, 29 Dec 2014 22:45:42 -0800
In-Reply-To: <1419864510-24834-1-git-send-email-a.hajda@samsung.com> (Andrzej
	Hajda's message of "Mon, 29 Dec 2014 15:48:26 +0100")
Message-ID: <87egrhws89.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrzej Hajda <a.hajda@samsung.com> writes:

> kstrdup if often used to duplicate strings where neither source neither
> destination will be ever modified. In such case we can just reuse the source
> instead of duplicating it. The problem is that we must be sure that
> the source is non-modifiable and its life-time is long enough.

What happens if someone is to kfree() these strings?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
