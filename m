Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278Ab3CMVBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:01:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:01:05 -0400
Date: Wed, 13 Mar 2013 14:01:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v5 1/2] mm: limit growth of 3% hardcoded other user
 reserve
Message-Id: <20130313140102.234330566fd08a0c8e4e2732@linux-foundation.org>
In-Reply-To: <20130307015553.GA5495@localhost.localdomain>
References: <20130306235201.GA1421@localhost.localdomain>
	<20130312160136.b0f09ca7b1b4f2efe01f6617@linux-foundation.org>
	<20130307015553.GA5495@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 20:55:53 -0500 Andrew Shewmaker <agshew@gmail.com> wrote:

> Should I enforce a minimum for the admin reserve? 8MB/128MB for the 
> overcommit guess/never modes? I was hesitant to do that since my 
> numbers are based a full-featured distro's versions of login, bash,
> etc. A more svelte distro based on BusyBox might want different 
> minimums.

I'd say not.  It requires CAP_SYS_ADMIN and we generally prefer to give
root the flexibility to shoot his foot off if he feels so inclined.

> I have a question concerning the variable names. Might a person 
> looking at the source be confused why admin_reserve_kbytes and 
> user_reserve_kbytes are not included in totalreserve_pages? Should 
> I use a word other than "reserve" in the names, like "safetynet"? 
> I can't think of anything better. Maybe it isn't a concern, but 
> I didn't want to cause confusion.

mm..  I wouldn't worry about it personally.  As long as we have nice
comments at the various definition sites, readers should be able to
work out the difference quite easily.

