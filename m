Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbaH1Baf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:30:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60825 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaH1Bab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:30:31 -0400
Message-ID: <53FE8633.10305@amacapital.net>
Date: Wed, 27 Aug 2014 18:30:27 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>	<20140827130613.c8f6790093d279a447196f17@linux-foundation.org>	<20140827211250.GH3285@linux.intel.com> <20140827144622.ed81195a1d94799bb57a3207@linux-foundation.org>
In-Reply-To: <20140827144622.ed81195a1d94799bb57a3207@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 02:46 PM, Andrew Morton wrote:
> I assume (because I wasn't told!) that there are two objectives here:
> 
> 1) reduce memory consumption by not maintaining pagecache and
> 2) reduce CPU cost by avoiding the double-copies.
> 
> These things are pretty easily quantified.  And really they must be
> quantified as part of the developer testing, because if you find
> they've worsened then holy cow, what went wrong.
> 

There are two more huge ones:

3) Writes via mmap are immediately durable (or at least they're durable
after a *very* lightweight flush).

4) No page faults ever once a page is writable (I hope -- I'm not sure
whether this series actually achieves that goal).

A note on #3: there is ongoing work to enable write-through memory for
things like this.  Once that's done, then writes via mmap might actually
be synchronously durable, depending on chipset details.

--Andy
