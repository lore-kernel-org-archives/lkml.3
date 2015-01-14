Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbbANS1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:27:06 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:54671 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbANS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:27:04 -0500
Date: Wed, 14 Jan 2015 21:27:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: account pmd page tables to the process
Message-ID: <20150114182700.GG2253@moon>
References: <1421254316-190596-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421254316-190596-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 06:51:56PM +0200, Kirill A. Shutemov wrote:
> Dave noticed that unprivileged process can allocate significant amount
> of memory -- >500 MiB on x86_64 -- and stay unnoticed by oom-killer and
> memory cgroup. The trick is to allocate a lot of PMD page tables. Linux
> kernel doesn't account PMD tables to the process, only PTE.
> 
> The use-cases below use few tricks to allocate a lot of PMD page tables
> while keeping VmRSS and VmPTE low. oom_score for the process will be 0.

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
