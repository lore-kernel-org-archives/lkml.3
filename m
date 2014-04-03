Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaDCQ5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:57:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33309 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaDCQ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:57:10 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
	<1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
	<alpine.DEB.2.10.1403311334060.3313@nuc>
	<1396291441.21529.52.camel@joe-AO722>
	<alpine.DEB.2.10.1404031132310.21658@nuc>
Date: Thu, 03 Apr 2014 09:57:11 -0700
In-Reply-To: <alpine.DEB.2.10.1404031132310.21658@nuc> (Christoph Lameter's
	message of "Thu, 3 Apr 2014 11:33:15 -0500 (CDT)")
Message-ID: <vnkwha6a1hco.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03 2014 at 09:33:15 AM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 31 Mar 2014, Joe Perches wrote:
>
>> On Mon, 2014-03-31 at 13:35 -0500, Christoph Lameter wrote:
>> > On Thu, 27 Mar 2014, Mitchel Humpherys wrote:
>> >
>> > > diff --git a/mm/slub.c b/mm/slub.c
>> []
>> > > @@ -9,6 +9,8 @@
>> > >   * (C) 2011 Linux Foundation, Christoph Lameter
>> > >   */
>> > >
>> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> >
>> > This is implicitly used by some macros? If so then please define this
>> > elsewhere. I do not see any use in slub.c of this one.
>>
>> Hi Christoph
>>
>> All the pr_<level> macros use it.
>>
>> from include/linux/printk.h:
>
> Ok then why do you add the definition to slub.c?

Ah that was an oversight on my part after changing to pr_cont. I'll send
a v3 that removes the pr_fmt. Or I could send a v3 that leaves the
pr_fmt but changes the printk that the pr_cont's are continuing (at the
top of note_cmpxchg_failure) to pr_info, but that wouldn't be consistent
with the rest of the file, which is using hand-tagged printk's.

I don't know if it's worthwhile to convert all of the hand-tagged
printk's to the pr_ macros, but if so I can do that in a separate patch.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
