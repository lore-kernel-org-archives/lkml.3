Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaLZWMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 17:12:33 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36998 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLZWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 17:12:31 -0500
Date: Fri, 26 Dec 2014 17:12:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] drivers:ata: Remove unneeded fix me comment for the
 function,mv_print_info in sata_mv.c
Message-ID: <20141226221227.GC10889@htj.dyndns.org>
References: <1419630959-2889-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419630959-2889-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nicholas.

On Fri, Dec 26, 2014 at 04:55:59PM -0500, Nicholas Krause wrote:
> Removes a unneed fix me comment for the function,mv_print_info in sata_mv.c.
> This function is correctly completed due to printing out needed info about 
> hardware to the kernel log buffer. The needed information that is being 
> printed successfully now to the callers of this function is the host 
> number of ports, the generation of hardware, the maximum q depth the
> hardware supports, if the hardware is either RAID or SCSI enabled and
> finally the IRQ mode enabled when called and the flag enabled with the
> respectful IRQ called. 

It's often more effective to discuss to conclusion on thread before
sending another patch.

When tracking down FIXME comments, it's often a good idea to look at
how the comment came to be by digging through the history.  git blame
on the file shows that the comment was added by 05b308e1df6d ("[PATCH]
libata: Marvell function headers") a long time ago.  Compared to then,
the function grew generation info printing, which could have been what
the original FIXME author had in mind or maybe not.  Regardless, given
that nobody has complained about lacking information over the years,
it can be argued that the FIXME is spurious.

So, I don't object to the patch itself.  These are just taking way too
much effort given that the actual gain is almost nil.  If you want to
continue to do this, please research about the history of FIXME and
construct and present a valid rationale for the change.  For this one,
listing what it prints out doesn't constitute rationale in itself.

Please do keep in mind these changes are ultimately frivolous.  If
they incur more cost than they're beneficial, they're pointless, so
please send properly formed and reasoned patches.  This probably is my
last response on the subject.

Thanks.

-- 
tejun
