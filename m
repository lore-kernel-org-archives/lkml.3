Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbbAWAGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:06:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbAWAGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:06:21 -0500
Date: Thu, 22 Jan 2015 16:06:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: provide a find_special_page vma operation
Message-Id: <20150122160620.e5e3f98ad58020832d899352@linux-foundation.org>
In-Reply-To: <1421682443-20509-2-git-send-email-david.vrabel@citrix.com>
References: <1421682443-20509-1-git-send-email-david.vrabel@citrix.com>
	<1421682443-20509-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015 15:47:22 +0000 David Vrabel <david.vrabel@citrix.com> wrote:

> The optional find_special_page VMA operation is used to lookup the
> pages backing a VMA.  This is useful in cases where the normal
> mechanisms for finding the page don't work.  This is only called if
> the PTE is special.
> 
> One use case is a Xen PV guest mapping foreign pages into userspace.
> 
> In a Xen PV guest, the PTEs contain MFNs so get_user_pages() (for
> example) must do an MFN to PFN (M2P) lookup before it can get the
> page.  For foreign pages (those owned by another guest) the M2P lookup
> returns the PFN as seen by the foreign guest (which would be
> completely the wrong page for the local guest).
> 
> This cannot be fixed up improving the M2P lookup since one MFN may be
> mapped onto two or more pages so getting the right page is impossible
> given just the MFN.

Acked-by: Andrew Morton <akpm@linux-foundation.org>
