Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbbAUW67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:58:59 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42788 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbAUW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:58:51 -0500
Date: Wed, 21 Jan 2015 14:58:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Petr Cermak <petrcermak@chromium.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
In-Reply-To: <20150114233630.GA14615@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.10.1501211452580.2716@chino.kir.corp.google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi> <20150114152225.GB31484@google.com> <20150114233630.GA14615@node.dhcp.inet.fi>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Kirill A. Shutemov wrote:

> I'm not sure if it should be considered ABI break or not. Just asking.
> 
> I would like to hear opinion from other people.
>  

I think the bigger concern would be that this, and any new line such as 
resettable_hiwater_rss, invalidates itself entirely.  Any process that 
checks the hwm will not know of other processes that reset it, so the 
value itself has no significance anymore.  It would just be the mark since 
the last clear at an unknown time.  Userspace can monitor the rss of a 
process by reading /proc/pid/stat, there's no need for the kernel to do 
something that userspace can do.
