Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaE3Baa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:30:30 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57986 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaE3Ba2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyvn_fTnWEmTCSGgfM18c21-YDU_s=FJP=grDDLQe+aDA@mail.gmail.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<20140529015830.GG6677@dastard>
	<20140529233638.GJ10092@bbox>
	<CA+55aFyvn_fTnWEmTCSGgfM18c21-YDU_s=FJP=grDDLQe+aDA@mail.gmail.com>
Date: Thu, 29 May 2014 18:30:26 -0700
X-Google-Sender-Auth: dbxrRcgGtP2WEvxxu8JmePw0aHA
Message-ID: <CA+55aFxni7MFPqdNh7LFssAaLLPP0nuvx-6OSdAU3vEqEdmWPw@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 5:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So maybe test a patch something like the attached.
>
> NOTE! This is absolutely TOTALLY UNTESTED!

It's still untested, but I realized that the whole
"blk_flush_plug_list(plug, true);" thing is pointless, since
schedule() itself will do that for us.

So I think you can remove the

+       struct blk_plug *plug = current->plug;
+       if (plug)
+               blk_flush_plug_list(plug, true);

part from congestion_timeout().

Not that it should *hurt* to have it there, so I'm not bothering to
send a changed patch.

And again, no actual testing by me on any of this, just looking at the code.

           Linus
