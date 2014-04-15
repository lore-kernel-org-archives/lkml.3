Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaDOOJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:09:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDOOJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:09:04 -0400
Message-ID: <534D3D4E.9080408@redhat.com>
Date: Tue, 15 Apr 2014 10:08:14 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter [v4]
References: <1396365545-12279-1-git-send-email-prarit@redhat.com> <20140414142914.57110976dd96134875b63639@linux-foundation.org> <20140414224042.GG22728@two.firstfloor.org>
In-Reply-To: <20140414224042.GG22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/14/2014 06:40 PM, Andi Kleen wrote:
>> Let's not leak all those blacklist entries when we're finished?
> 
> It's difficult, because you cannot free bootmem after bootmem is
> finished.
> 
> For the rare debug case some leaking should be acceptable.
> 

Andrew, FWIW I agree with Andi on this.  It is a minor leak in a debug
situation.  I'd also like to know in a kdump situation what was specified as
blacklisted so keeping this memory around is IMO a good idea.

P.

> -Andi
> 
