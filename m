Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbbANXkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:40:01 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:32915 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbbANXkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:40:00 -0500
Date: Thu, 15 Jan 2015 01:39:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Petr Cermak <petrcermak@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
Message-ID: <20150114233954.GB14615@node.dhcp.inet.fi>
References: <20150107172452.GA7922@node.dhcp.inet.fi>
 <20150114152225.GB31484@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114152225.GB31484@google.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:22:25PM +0000, Petr Cermak wrote:
> On Wed, Jan 07, 2015 at 07:24:52PM +0200, Kirill A. Shutemov wrote:
> > And how it's not an ABI break?
> I don't think this is an ABI break because the current behaviour is not
> changed unless you write "5" to /proc/pid/clear_refs. If you do, you are
> explicitly requesting the new functionality.
> 
> > We have never-lowering VmHWM for 9+ years. How can you know that nobody
> > expects this behaviour?
> This is why we sent an RFC [1] several weeks ago. We expect this to be
> used mainly by performance-related tools (e.g. profilers) and from the
> comments in the code [2] VmHWM seems to be a best-effort counter. If this
> is strictly a no-go, I can only think of the following two alternatives:
> 
>   1. Add an extra resettable field to /proc/pid/status (e.g.
>      resettable_hiwater_rss). While this doesn't violate the current
>      definition of VmHWM, it adds an extra line to /proc/pid/status,
>      which I think is a much bigger issue.
>   2. Introduce a new proc fs file to task_mmu (e.g.
>      /proc/pid/profiler_stats), but this feels like overengineering.

BTW, we have memory.max_usage_in_byte in memory cgroup. And it's resetable.
Wouldn't it be enough for your profiling use-case?

-- 
 Kirill A. Shutemov
