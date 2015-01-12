Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbALU6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:58:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbALU6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:58:47 -0500
Date: Mon, 12 Jan 2015 12:58:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCHv2 0/2] mm: infrastructure for correctly handling foreign
 pages on Xen
Message-Id: <20150112125846.4a5a6418c5c130c1b7669086@linux-foundation.org>
In-Reply-To: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
References: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 15:53:11 +0000 David Vrabel <david.vrabel@citrix.com> wrote:

> These two patches are the common parts of a larger Xen series[1]
> fixing several long-standing bugs the handling of foreign[2] pages in
> Xen guests.
> 
> The first patch is required to fix get_user_pages[_fast]() with
> userspace space mappings of such foreign pages.  Basically, pte_page()
> doesn't work so an alternate mechanism is needed to get the page from
> a VMA and address.  By requiring mappings needing this method are
> 'special' this should not have an impact on the common use cases.
> 
> The second patch isn't essential but helps with readability of the
> resulting user of the page flag.
> 
> For further background reading see:
> 
>   http://xenbits.xen.org/people/dvrabel/grant-improvements-C.pdf
> 

Looks OK to me.  I can merge them if you like, but it's probably more
convenient for you to include them in the Xen tree.

It would be nice if PG_foreign (and PG_everythingelse) was properly
documented at the definition site.
