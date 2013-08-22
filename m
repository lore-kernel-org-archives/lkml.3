Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3HVQvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:51:35 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:44667 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab3HVQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:51:33 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 12:51:33 EDT
Date: Thu, 22 Aug 2013 16:44:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
In-Reply-To: <20130821134945.16b32c045e28272c5b0ba610@linux-foundation.org>
Message-ID: <00000140a6e964d2-03ac778f-13ff-415d-bbfa-93cb2fddcaa5-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com> <1375896905-6074-5-git-send-email-kmo@daterainc.com> <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com> <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com> <20130807195733.GB11612@kmo-pixel> <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com> <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <00000140a14ae6bb-f0fca267-cdd6-4039-8c6b-f715999a83c5-000000@email.amazonses.com> <20130821134945.16b32c045e28272c5b0ba610@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.22-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Andrew Morton wrote:

> The lock is needed so that one cpu can steal tags from another cpu's cache.
> See (the needlessly inlined!) steal_tags().

Stealing tags could also be done via IPIs or some other things.

