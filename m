Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3HTVM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:12:26 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46279 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3HTVMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:12:25 -0400
Message-ID: <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Kent Overstreet <kmo@daterainc.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Date: Tue, 20 Aug 2013 14:19:06 -0700
In-Reply-To: <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
	 <1375896905-6074-5-git-send-email-kmo@daterainc.com>
	 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
	 <20130807183345.GA11612@kmo-pixel>
	 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
	 <20130807195733.GB11612@kmo-pixel>
	 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 14:32 +0000, Christoph Lameter wrote:
> On Wed, 7 Aug 2013, Kent Overstreet wrote:
> 
> > One thing that was bugging me - I was never able to figure out for sure
> > if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
> > least I couldn't find where it was documented - could you tell me if
> > that's true?
> 
> I always assumed that it was in the range 0 ... nr_cpu_ids - 1 and that is
> the assumption under which the kernel code was written. Things would break
> horribly if smp_process_id would return nr_cpu_ids or higher.
> 

Hi guys,

Just a heads up that I've put Kent's standalone percpu-ida patch (with
Christoph's recommend changes) into target-pending/for-next here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=47bd524a5b3eb6429b058b8b562b45329ab2c9e7

I've got a number of target patches that depend on this code for v3.12,
and a delay on this particular piece would be painful to endure..

Sooo, please yell loudly if there is an objection to percpu-ida merge as
a completely standalone item, that does not effect any existing ida
code.

--nab

