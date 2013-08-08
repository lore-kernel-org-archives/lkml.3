Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478Ab3HHOqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:46:50 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:51921 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965438Ab3HHOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:46:47 -0400
X-Greylist: delayed 879 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 10:46:47 EDT
Date: Thu, 8 Aug 2013 14:32:05 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Kent Overstreet <kmo@daterainc.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
In-Reply-To: <20130807195733.GB11612@kmo-pixel>
Message-ID: <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com> <1375896905-6074-5-git-send-email-kmo@daterainc.com> <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com> <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com> <20130807195733.GB11612@kmo-pixel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.08-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Kent Overstreet wrote:

> One thing that was bugging me - I was never able to figure out for sure
> if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
> least I couldn't find where it was documented - could you tell me if
> that's true?

I always assumed that it was in the range 0 ... nr_cpu_ids - 1 and that is
the assumption under which the kernel code was written. Things would break
horribly if smp_process_id would return nr_cpu_ids or higher.

