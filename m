Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaKLCKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:10:39 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47118 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaKLCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:10:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141111142344.b4eb11c6e3c240d345fdd995@linux-foundation.org>
References: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
	<20141111142344.b4eb11c6e3c240d345fdd995@linux-foundation.org>
Date: Wed, 12 Nov 2014 10:10:36 +0800
Message-ID: <CAL1ERfO5GNanwLkL36b11NDUTptzGrxVF=rN913bHjS9wFNWKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: page_isolation: check pfn validity before access
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Weijie Yang <weijie.yang@samsung.com>, kamezawa.hiroyu@jp.fujitsu.com,
        Minchan Kim <minchan@kernel.org>, mgorman@suse.de, mina86@mina86.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 6:23 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 06 Nov 2014 16:08:02 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
>
>> In the undo path of start_isolate_page_range(), we need to check
>> the pfn validity before access its page, or it will trigger an
>> addressing exception if there is hole in the zone.
>>
>
> There is not enough information in the chagnelog for me to decide how
> to handle the patch.  3.19?  3.18? 3.18+stable?
>
> When fixing bugs, please remember to fully explain the end-user impact
> of the bug.  Under what circumstances does it occur?

I'm sorry to disturb you. This issue is found by code-review not a test-trigger.
In "CONFIG_HOLES_IN_ZONE" environment, there is a certain chance that
it would casue an addressing exception when start_isolate_page_range() fails,
this could affect CMA, hugepage and memory-hotplug function.
