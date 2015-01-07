Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbbAGRZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:25:06 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:44304 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbbAGRZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:25:01 -0500
Date: Wed, 7 Jan 2015 19:24:52 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Petr Cermak <petrcermak@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
Message-ID: <20150107172452.GA7922@node.dhcp.inet.fi>
References: <cover.1420643264.git.petrcermak@chromium.org>
 <be6c14c9ac4551e94b814c5789242b4874a25dd3.1420643264.git.petrcermak@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be6c14c9ac4551e94b814c5789242b4874a25dd3.1420643264.git.petrcermak@chromium.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:06:54PM +0000, Petr Cermak wrote:
> Peak resident size of a process can be reset by writing "5" to
> /proc/pid/clear_refs. The driving use-case for this would be getting the
> peak RSS value, which can be retrieved from the VmHWM field in
> /proc/pid/status, per benchmark iteration or test scenario.

And how it's not an ABI break?

We have never-lowering VmHWM for 9+ years. How can you know that nobody
expects this behaviour?

And why do you reset hiwater_rss, but not hiwater_vm?

-- 
 Kirill A. Shutemov
