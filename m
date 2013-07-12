Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab3GLQx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:53:27 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:33384 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884Ab3GLQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:53:26 -0400
Message-ID: <51E0348A.2030208@opengridcomputing.com>
Date: Fri, 12 Jul 2013 11:53:30 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Oops mystery
References: <51E02545.7080106@opengridcomputing.com> <20130712164816.GE1020@redhat.com>
In-Reply-To: <20130712164816.GE1020@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 11:48 AM, Dave Jones wrote:
> On Fri, Jul 12, 2013 at 10:48:21AM -0500, Steve Wise wrote:
>   
>   > So 'movb   $0x0,0xe(%rax,%rdx,1)' should be storing 0 into the byte
>   > location:
>   >
>   > %rax + 0xe + (%rdx * 1) ==
>   > 0x40fc+ 0xe + 0xffff8808b5500000 ==
>   > 0xffff8808b5540fce.
>   >
>   > That address is readable in the crash dump:
>   >
>   > crash> x/8b 0x0000000000040fc0+0xe+0xffff8808b5500000
>   > 0xffff8808b5540fce:     0x00    0x00    0x00    0x00    0x00 0x00
>   > 0x00    0x00
>   >
>   > And why does the page fault show 0x40fc0 as the faulting address?  It
>   > should be 0xffff8808b5540fce and it shouldn't have caused a page fault.
>   >
>   > What am I missing?
>
> Random guess: Is that page marked read-only perhaps ?

It shouldn't be. :)  How can I get this info via the crash dump? The 
memory was allocated with dma_alloc_coherent().   Why would the page 
fault occur on 0x40fc0 though?  That makes me think my analysis so far 
is incorrect.


Steve.
