Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaLVSFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:05:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbaLVSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:05:37 -0500
Message-ID: <54985D59.5010506@oracle.com>
Date: Mon, 22 Dec 2014 13:05:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "david S. Miller" <davem@davemloft.net>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, dave@stgolabs.net
Subject: Re: mm: NULL ptr deref in unlink_file_vma
References: <549832E2.8060609@oracle.com> <20141222180102.GA8072@node.dhcp.inet.fi>
In-Reply-To: <20141222180102.GA8072@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 01:01 PM, Kirill A. Shutemov wrote:
> On Mon, Dec 22, 2014 at 10:04:02AM -0500, Sasha Levin wrote:
>> > Hi all,
>> > 
>> > While fuzzing with trinity inside a KVM tools guest running the latest -next
>> > kernel, I've stumbled on the following spew:
>> > 
>> > [  432.376425] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>> > [  432.378876] IP: down_write (./arch/x86/include/asm/rwsem.h:105 ./arch/x86/include/asm/rwsem.h:121 kernel/locking/rwsem.c:71)
> Looks like vma->vm_file->mapping is NULL. Somebody freed ->vm_file from
> under us?
> 
> I suspect Davidlohr's patchset on i_mmap_lock, but I cannot find any code
> path which could lead to the crash.

I've reported a different issue which that patchset: https://lkml.org/lkml/2014/12/9/741

I guess it could be related?


Thanks,
Sasha
