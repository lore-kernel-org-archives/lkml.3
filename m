Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3HGSBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:01:15 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:61447 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab3HGSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <520286A4.1020101@intel.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
 <520286A4.1020101@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Aug 2013 11:00:52 -0700
Message-ID: <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
To: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 10:40 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 08/07/2013 06:40 AM, Jan Kara wrote:
>>   One question before I look at the patches: Why don't you use fallocate()
>> in your application? The functionality you require seems to be pretty
>> similar to it - writing to an already allocated block is usually quick.
>
> One problem I've seen is that it still costs you a fault per-page to get
> the PTEs in to a state where you can write to the memory.  MADV_WILLNEED
> will do readahead to get the page cache filled, but it still leaves the
> pages unmapped.  Those faults get expensive when you're trying to do a
> couple hundred million of them all at once.

I have grand plans to teach the kernel to use hardware dirty tracking
so that (some?) pages can be left clean and writable for long periods
of time.  This will be hard.

Even so, the second write fault to a page tends to take only a few
microseconds, while the first one often blocks in fs code.

(mmap_sem is a different story, but I see it as a separate issue.)

--Andy
