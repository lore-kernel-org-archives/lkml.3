Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3B1KtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:49:16 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58864 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3B1KtP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 28 Feb 2013 05:49:15 -0500
Message-Id: <512F443702000078000C1DF7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 10:49:11 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 00/12] xen-block: indirect
 descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
> This series contains the initial implementation of indirect 
> descriptors for Linux blkback/blkfront.
> 
> Patches 1, 2, 3, 4 and 5 are bug fixes and minor optimizations.
> 
> Patch 6 contains a LRU implementation for blkback that will be needed 
> when using indirect descriptors (since we are no longer able to map 
> all possible grants blkfront might use).

Considering this, ...

> Patch 7 is an addition to the print stats function in blkback in order 
> to print information regarding persistent grant usage.
> 
> Patches 8, 9, 10 and 11 are preparatory work for indirect descriptors 
> implementation, mainly make blkback use dynamic memory and remove the 
> shared blkbk structure, so each blkback instance has it's own list of 
> free requests, pages, handles and so on.
> 
> Finally patch 12 contains the indirect descriptors implementation.
> 
> I've also pushed this series to the following git repository:
> 
> git://xenbits.xen.org/people/royger/linux.git xen-block-indirect
> 
> Performance benefit of this series can be seen in the following graph:
> 
> http://xenbits.xen.org/people/royger/plot_indirect.png 

... would you happen to also have a comparison with using
indirect descriptors but not persistent grants? IOW I'm
wondering about the hit rate on the persistently mapped
grants, especially when blkfront really saturates the added
bandwidth.

Jan

