Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3DOFsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:48:22 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37328 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3DOFsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:48:20 -0400
Date: Mon, 15 Apr 2013 07:48:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: arch/s390/lib/uaccess_pt.c: Missing breaks: ?
Message-ID: <20130415054814.GA4207@osiris>
References: <1365919574.1878.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365919574.1878.13.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041505-5024-0000-0000-000005C11292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 11:06:14PM -0700, Joe Perches wrote:
> Hello Heiko.
> 
> Commit ea81531d ("s390/uaccess: fix page table walk")
> added this code.  It looks like it should have break;
> for each case.

Hi Joe,

no, the fallthrough is on purpose for each case statement.

> static unsigned long follow_table(struct mm_struct *mm,
> 				  unsigned long address, int write)
> {
> 	unsigned long *table = (unsigned long *)__pa(mm->pgd);
> 
> 	switch (mm->context.asce_bits & _ASCE_TYPE_MASK) {
> 	case _ASCE_TYPE_REGION1:
> 		table = table + ((address >> 53) & 0x7ff);
> 		if (unlikely(*table & _REGION_ENTRY_INV))
> 			return -0x39UL;
> 		table = (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
> 	case _ASCE_TYPE_REGION2:

