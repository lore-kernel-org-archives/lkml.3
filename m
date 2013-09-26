Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3IZSFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:05:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3IZSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:05:40 -0400
Date: Thu, 26 Sep 2013 11:05:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on
 "n_tty: Move buffers into n_tty_data"
Message-Id: <20130926110551.52ad8156.akpm@linux-foundation.org>
In-Reply-To: <52447064.5030902@hurleysoftware.com>
References: <20130913005133.GA32479@localhost>
	<20130913010936.GA1291@localhost>
	<5238767D.1080606@hurleysoftware.com>
	<20130917232214.GA11390@localhost>
	<5238F252.5070905@hurleysoftware.com>
	<20130926003315.2e81bc84.akpm@linux-foundation.org>
	<52441B23.7050704@hurleysoftware.com>
	<20130926150421.GA25545@kroah.com>
	<52447064.5030902@hurleysoftware.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013 13:35:32 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:

> The issue with a single large kmalloc is that it may fail where
> 3 separate, page-or-less kmallocs would not have.

Or vmalloc fails first, because of internal fragmentation of the vmap
arena.  This problem plus vmalloc's slowness are the reasons why
vmalloc should be avoided.

A tremendous number of places in the kernel perform higher-order
allocations nowadays.  The page allocator works damn hard to service
them and I expect that switching to kmalloc here will be OK.
