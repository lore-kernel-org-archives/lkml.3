Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3HGRkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:40:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:45682 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab3HGRky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,834,1367996400"; 
   d="scan'208";a="279008283"
Message-ID: <520286A4.1020101@intel.com>
Date: Wed, 07 Aug 2013 10:40:52 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
In-Reply-To: <20130807134058.GC12843@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:40 AM, Jan Kara wrote:
>   One question before I look at the patches: Why don't you use fallocate()
> in your application? The functionality you require seems to be pretty
> similar to it - writing to an already allocated block is usually quick.

One problem I've seen is that it still costs you a fault per-page to get
the PTEs in to a state where you can write to the memory.  MADV_WILLNEED
will do readahead to get the page cache filled, but it still leaves the
pages unmapped.  Those faults get expensive when you're trying to do a
couple hundred million of them all at once.
