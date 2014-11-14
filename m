Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953AbaKNBFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:05:00 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:33685 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017AbaKNBE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:04:58 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Weijie Yang <weijie.yang@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: mincore: add hwpoison page handle
Thread-Topic: [PATCH] mm: mincore: add hwpoison page handle
Thread-Index: AQHP/6ay7aowfdzmykuN6gvNmBZv8A==
Date: Fri, 14 Nov 2014 01:02:44 +0000
Message-ID: <20141114010320.GA15456@hori1.linux.bs1.fc.nec.co.jp>
References: <000001cffe2a$66a95a50$33fc0ef0$%yang@samsung.com>
 <20141112142022.GA29766@phnom.home.cmpxchg.org>
In-Reply-To: <20141112142022.GA29766@phnom.home.cmpxchg.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.26]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <0A7C1CF4A75A604EAC87CC5EE2420470@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 09:20:22AM -0500, Johannes Weiner wrote:
> On Wed, Nov 12, 2014 at 11:39:29AM +0800, Weijie Yang wrote:
> > When encounter pte is a swap entry, the current code handles two cases:
> > migration and normal swapentry, but we have a third case: hwpoison page.
> > 
> > This patch adds hwpoison page handle, consider hwpoison page incore as
> > same as migration.
> > 
> > Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> 
> The change makes sense:
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> But please add a description of what happens when a poison entry is
> encountered with the current code.  I'm guessing swap_address_space()
> will return garbage and this might crash the kernel?

Yes, I think that's correct.

Thanks,
Naoya Horiguchi