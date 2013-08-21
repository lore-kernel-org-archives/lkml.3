Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3HUCHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:07:48 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36036 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3HUCHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:07:46 -0400
Date: Tue, 20 Aug 2013 22:07:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821020742.GA3495@htj.dyndns.org>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-5-git-send-email-kmo@daterainc.com>
 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
 <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
 <20130807195733.GB11612@kmo-pixel>
 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
 <20130821020132.GA4051@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821020132.GA4051@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Aug 20, 2013 at 07:01:32PM -0700, Kent Overstreet wrote:
> I think Tejun and I might be at a bit of an impasse with the ida rewrite
> itself, but I don't think there were any outstanding objections to the
> percpu ida code itself - and this is a standalone version.

The percpu ida code can be applied separately from the ida rewrite?

> I was meaning to ask you Andrew, if you could take a look at the ida
> discussion and lend your opinion - I don't think there's any _specific_
> technical objections left to my ida code, and it's now on a more
> philisophical "complexity vs. ..." level.

Hmmm... the objection was pretty specific - don't depend on high-order
or vmalloc allocations when it can be easily avoided by using proper
radix tree.

Thanks.

-- 
tejun
