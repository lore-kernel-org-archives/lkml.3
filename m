Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaESWGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:06:16 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38375 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaESWGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <537A445E.5030604@intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz> <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org> <20140519150238.67898E009B@blue.fi.intel.com>
 <20140519151104.GA16736@infradead.org> <20140519151758.A2162E009B@blue.fi.intel.com>
 <CAMSv6X1-17HMTO=b6QOZA0Xm1combFxV4wuX1gPMUqC02EKrJA@mail.gmail.com>
 <20140519155336.86E93E009B@blue.fi.intel.com> <CAMSv6X2EmhgVou03oLTAhpGbNv712mbNWCpL2PXWCXpW9M2nCQ@mail.gmail.com>
 <537A445E.5030604@intel.com>
From: Armin Rigo <arigo@tunes.org>
Date: Tue, 20 May 2014 00:05:34 +0200
X-Google-Sender-Auth: lHWKupfxHMfW19FtqCqXighlE1s
Message-ID: <CAMSv6X37NL0JHQgtbhqdNXM_-bCcxK42YQDHqA9m=uMj3SAZxQ@mail.gmail.com>
Subject: Re: remap_file_pages() use
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 19 May 2014 19:50, Dave Hansen <dave.hansen@intel.com> wrote:
> We keep the current count as mm->map_count in the kernel, and the limit
> is available because it's a sysctl.  It wouldn't be hard to dump
> mm->map_count out in a /proc file somewhere if it would be useful to
> you.  Would that work, or is there some other interface that would be
> more convenient?

We can keep an in-process estimate of this value anyway.  The sysctl
to get vm.max_map_count is all we need.  That is, unless the limit is
moved to be per-user instead of per-process, as I think was discussed
here --- which would complicate further our job :-/


A bientôt,

Armin.
