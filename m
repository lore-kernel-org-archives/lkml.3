Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3HZVuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:50:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3HZVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:50:01 -0400
Date: Mon, 26 Aug 2013 14:49:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v2] [BUGFIX] drivers/base: fix show_mem_removable to
 handle missing sections
Message-Id: <20130826144959.52fd24cd2833929168ee7e35@linux-foundation.org>
In-Reply-To: <20130823162317.GB10988@sgi.com>
References: <20130823162317.GB10988@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013 11:23:17 -0500 Russ Anderson <rja@sgi.com> wrote:

> "cat /sys/devices/system/memory/memory*/removable" crashed the system.
> 
> The problem is that show_mem_removable() is passing a
> bad pfn to is_mem_section_removable(), which causes
> if (!node_online(page_to_nid(page))) to blow up.
> Why is it passing in a bad pfn?
> 
> show_mem_removable() will loop sections_per_block times.
> sections_per_block is 16, but mem->section_count is 8,
> indicating holes in this memory block.  Checking that
> the memory section is present before checking to see
> if the memory section is removable fixes the problem.

The patch textually applies to 3.10, 3.9 and perhaps earlier.  Should
it be applied to earlier kernels?

