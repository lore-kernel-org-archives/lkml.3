Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbaFSQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:36:26 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:43828 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbaFSQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:36:25 -0400
Date: Thu, 19 Jun 2014 19:36:14 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Maloney <peter.maloney@brockmann-consult.de>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Kamal Mostafa <kamal@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: kernel BUG - handle_mm_fault - Ubuntu 14.04 kernel
 3.13.0-29-generic
Message-ID: <20140619163614.GA24297@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A30B63.107@brockmann-consult.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 06:10:11PM +0200, Peter Maloney wrote:
> Hi, can someone please take a look at this and tell me what is going on?
> 
> The event log reports no ECC errors.
> 
> This machine was working fine with an older Ubuntu version, and has
> failed this way twice since an upgrade 2 weeks ago.
> 
> Symptoms include:
>  - load goes up high, currently 1872.72
>  - "ps -ef" hangs
>  - this time I tested "echo w > /proc/sysrq-trigger" which made the
> local shell and ssh hang, and ctrl+alt+del doesn't work, but machine
> still responds to ping
> 
> Please CC me; I'm not on the list.
> 
> Thanks,
> Peter
> 
> 
> 
> Here's the log:
> 
> Jun 12 15:42:42 node73 kernel: [17196.908781] ------------[ cut here
> ]------------
> Jun 12 15:42:42 node73 kernel: [17196.909789] kernel BUG at
> /build/buildd/linux-3.13.0/mm/memory.c:3756!

Looks like this:

http://lkml.org/lkml/2014/5/8/275

It seems the commit 107437febd49 has added to 3.13.11.3 "extended stable",
but not in other -stable.

Rik, should it be there too?

-- 
 Kirill A. Shutemov
