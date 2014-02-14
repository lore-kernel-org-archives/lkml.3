Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaBNApY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:45:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBNApX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:45:23 -0500
Date: Thu, 13 Feb 2014 16:45:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-Id: <20140213164521.c656b6022287f387dddd5a2f@linux-foundation.org>
In-Reply-To: <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
References: <52F4B8A4.70405@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com>
	<52F88C16.70204@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
	<52F8C556.6090006@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
	<52FC6F2A.30905@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
	<52FC98A6.1000701@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
	<20140214001438.GB1651@linux.vnet.ibm.com>
	<CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 16:37:53 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  unsigned long max_sane_readahead(unsigned long nr)
>  {
>         return min(nr, 128);
>  }

I bet nobody will notice.

It should be 128*4096/PAGE_CACHE_SIZE so that variations in PAGE_SIZE
don't affect readahead behaviour.

