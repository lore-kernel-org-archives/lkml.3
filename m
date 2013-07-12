Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab3GLRCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103Ab3GLRCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:02:17 -0400
Date: Fri, 12 Jul 2013 13:00:46 -0400
From: Dave Jones <davej@redhat.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops mystery
Message-ID: <20130712170046.GB1537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steve Wise <swise@opengridcomputing.com>,
	linux-kernel@vger.kernel.org
References: <51E02545.7080106@opengridcomputing.com>
 <20130712164816.GE1020@redhat.com>
 <51E0348A.2030208@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0348A.2030208@opengridcomputing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:53:30AM -0500, Steve Wise wrote:
 > On 7/12/2013 11:48 AM, Dave Jones wrote:
 > > On Fri, Jul 12, 2013 at 10:48:21AM -0500, Steve Wise wrote:
 > >   
 > >   > So 'movb   $0x0,0xe(%rax,%rdx,1)' should be storing 0 into the byte
 > >   > location:
 > >   >
 > >   > %rax + 0xe + (%rdx * 1) ==
 > >   > 0x40fc+ 0xe + 0xffff8808b5500000 ==
 > >   > 0xffff8808b5540fce.
 > >   >
 > >   > That address is readable in the crash dump:
 > >   >
 > >   > crash> x/8b 0x0000000000040fc0+0xe+0xffff8808b5500000
 > >   > 0xffff8808b5540fce:     0x00    0x00    0x00    0x00    0x00 0x00
 > >   > 0x00    0x00
 > >   >
 > >   > And why does the page fault show 0x40fc0 as the faulting address?  It
 > >   > should be 0xffff8808b5540fce and it shouldn't have caused a page fault.
 > >   >
 > >   > What am I missing?
 > >
 > > Random guess: Is that page marked read-only perhaps ?
 > 
 > It shouldn't be. :)  How can I get this info via the crash dump? The 
 > memory was allocated with dma_alloc_coherent().   Why would the page 
 > fault occur on 0x40fc0 though?  That makes me think my analysis so far 
 > is incorrect.

Hmm, good point. Do you have the Code: line from the oops ?
Does that match the disassembly ?

	Dave

