Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaHLM2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:28:54 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63997 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaHLM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:28:53 -0400
Message-ID: <1407846532.10122.66.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: x86: vmalloc and THP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Oren Twaig <oren@scalemp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Date: Tue, 12 Aug 2014 05:28:52 -0700
In-Reply-To: <20140812060745.GA7987@node.dhcp.inet.fi>
References: <53E99F86.5020100@scalemp.com>
	 <20140812060745.GA7987@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 09:07 +0300, Kirill A. Shutemov wrote:
> On Tue, Aug 12, 2014 at 08:00:54AM +0300, Oren Twaig wrote:

> >Does memory allocated using vmalloc() will be mapped using huge
> >pages either directly or later by THP ? 
> 
> No. It's neither aligned properly, nor physically contiguous.
> 
> >If not, is there any fast way to change this behavior ? Maybe by
> >changing the granularity/alignment of such allocations to allow such
> >mapping ?
> 
> What's the point to use vmalloc() in this case?

Look at various large hashes we have in the system, all using
vmalloc() :

[    0.006856] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.033130] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    1.197621] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)

I would imagine a performance difference if we were using hugepages.



