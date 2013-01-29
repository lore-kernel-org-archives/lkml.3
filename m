Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3A2XDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:03:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3A2XDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:03:52 -0500
Date: Tue, 29 Jan 2013 15:03:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 6/7] zswap: add flushing support
Message-Id: <20130129150350.d0b51ca9.akpm@linux-foundation.org>
In-Reply-To: <1359495627-30285-7-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1359495627-30285-7-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:40:26 -0600
Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> This patchset adds support for flush pages out of the compressed
> pool to the swap device

I do so hate that word "flush".  Sometimes it means "writeback", other
times it means "invalidate".  And perhaps it means "copy elsewhere then
reclaim".

Please describe with great specificity what this patch actually does
with pages, and why it does it.  And where the compression factors into
this.

The code appears to take a compressed page, decompress it into
swapcache via some means.  And then, for unexplained reasons, it starts
writeback of that swapcache page.

In zswap_flush_entry() there is a comment "page is already in the swap
cache, ignore for now".  This is very interesting.  How and why does
this come about?  Does it imply that there are two copies of the same
data floating around?  If so, how come?

Preferably all the above would be understandable by reading mm/zswap.c.
