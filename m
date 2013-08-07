Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3HGTkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:40:19 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:46846 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757246Ab3HGTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:40:17 -0400
Date: Wed, 7 Aug 2013 19:40:15 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Kent Overstreet <kmo@daterainc.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/10] idr: Percpu ida
In-Reply-To: <20130807183345.GA11612@kmo-pixel>
Message-ID: <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com> <1375896905-6074-5-git-send-email-kmo@daterainc.com> <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com> <20130807183345.GA11612@kmo-pixel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.07-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Kent Overstreet wrote:

> I was breaking it apart because I was using this_cpu elsewhere too - for
> the bitmap of which cpus have non empty freelists.

this_cpu can be retrieved with smp_processor_id().

> Or is this_cpu_ptr() doing something smarter than per_cpu_ptr(ptr,
> smp_processer_id())? There's so many variants I'm not 100% sure they're
> the same.

Yes it is. It uses a sepecial register that contains the offset of this
cpus per cpu area instead of going through the table of all processor
offsets. Its less code.

