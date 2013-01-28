Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3A1QKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:10:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54508 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1QKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:10:44 -0500
Date: Mon, 28 Jan 2013 17:10:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/12] perf, x86: Add PEBSv2 record support
Message-ID: <20130128161038.GR30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-2-git-send-email-andi@firstfloor.org> <CABPqkBQFPX5iBoBy5eTanaLXOatXfF8NzHWffuN4ovbW0LmH1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQFPX5iBoBy5eTanaLXOatXfF8NzHWffuN4ovbW0LmH1Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you should call this: PEBS v3 and not v2.

v2 is the version number in the enumeration register.
It would be confusing to use a different numbering than Intel does.
That's also the numbering that is printed in dmesg.

> We already have 2 existing formats: core and nhm.
> You're adding the hsw format.
> 
> So either you add it as struct pebs_record_hsw or you
> cleanup the naming of all the structs and call them:

core is v0.

> 
> struct pebs_record_v1 /* core */
> struct pebs_record_v2 /* nhm, snb, ivb */
> struct pebs_record_v3 /* hsw */
> 
> That would seem more consistent to me.

I personally don't see a lot of need for a rename, but I can send 
a followon patch to rename nhm to v1 and core to v0. I will do that
separately because people are already complaining that the patchkit
is too big, and it doesn't really affect the functionality.

-Andi
