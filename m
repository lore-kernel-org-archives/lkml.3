Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaESRul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:50:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:23092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaESRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:50:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="542992340"
Message-ID: <537A445E.5030604@intel.com>
Date: Mon, 19 May 2014 10:50:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Armin Rigo <arigo@tunes.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: remap_file_pages() use
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com> <20140519130114.GA3140@dhcp22.suse.cz> <20140519143540.BE9F6E009B@blue.fi.intel.com> <20140519143837.GA5228@infradead.org> <20140519150238.67898E009B@blue.fi.intel.com> <20140519151104.GA16736@infradead.org> <20140519151758.A2162E009B@blue.fi.intel.com> <CAMSv6X1-17HMTO=b6QOZA0Xm1combFxV4wuX1gPMUqC02EKrJA@mail.gmail.com> <20140519155336.86E93E009B@blue.fi.intel.com> <CAMSv6X2EmhgVou03oLTAhpGbNv712mbNWCpL2PXWCXpW9M2nCQ@mail.gmail.com>
In-Reply-To: <CAMSv6X2EmhgVou03oLTAhpGbNv712mbNWCpL2PXWCXpW9M2nCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 09:42 AM, Armin Rigo wrote:
> If there is an official way to know in advance how many remappings our
> process is allowed to perform, then we could adapt as the size
> increases.  Or maybe catching ENOMEM and doubling the remapping size
> (in some process-wide synchronization point).  All in all, thanks for
> the note: it looks like there are solutions (even if less elegant than
> remap_file_pages from the user's perspective).

We keep the current count as mm->map_count in the kernel, and the limit
is available because it's a sysctl.  It wouldn't be hard to dump
mm->map_count out in a /proc file somewhere if it would be useful to
you.  Would that work, or is there some other interface that would be
more convenient?
