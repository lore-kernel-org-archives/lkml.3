Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3JPL4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:56:08 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57554 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab3JPL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:56:07 -0400
X-AuditID: cbfec372-b7fe76d000003347-f7-525e7ed4dd84
Date: Wed, 16 Oct 2013 08:55:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-id: <20131016085558.19fe143a@samsung.com>
In-reply-to: <20131016104221.GC13608@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
 <20131016091640.GA13608@pd.tnic>
 <20131016073539.5a48f65e.m.chehab@samsung.com> <20131016104221.GC13608@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/hIN0rdXFBBr9+61i0nfjNZvF5wz82
	i1vvbC2W7+tntLi8aw6bxf2Wp+wWZw4dYrR4c+EeiwOHx/fWPhaPxXteMnnMOxno8eDQZhaP
	9/uusnl83iQXwBbFZZOSmpNZllqkb5fAlXHl3jWWgg7+is7fS5gaGP9xdzFyckgImEic+3WN
	DcIWk7hwbz2QzcUhJLCEUeLbo9PsEE43k0T/0V6wKhYBVYn111tYQGw2ASOJV40trCC2iICS
	xNdFc5lAGpgFupgkzq34xA6SEBbwkjjVcocJxOYVMJTYv3gCmM0poCsx9fJyZogNS5klXkzZ
	ArSBA+gOJ4mtU30h6gUlfky+B7aMWUBLYvO2JlYIW15i85q3zBMYBWYhKZuFpGwWkrIFjMyr
	GEVLi5MLipPScw31ihNzi0vz0vWS83M3MUICv2gH47MNVocYBTgYlXh4FWJjg4RYE8uKK3MP
	MUpwMCuJ8EYExwUJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYFzKp+jEmdw6oaE24rPe1l389/sD
	5M+tCbsS67smfNq6cyFsNiFR4jnZ1fsl4vbHLrbtnp+kkutyIORMosrd2vci/SpMUT7CKk/K
	rE8tb/J5tW6rzOdTchnP5A+kyXxtT2jkPT+xRMPaqCTGd9Hsl8dF5M4c+vRfOerCo1ftC9ZW
	bKo/9WX/GiWW4oxEQy3mouJEAHjjvaFaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 12:42:21 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Wed, Oct 16, 2013 at 07:35:39AM -0300, Mauro Carvalho Chehab wrote:
> > Well, try to write some code on userspace to discover what's the error.
> > 
> > An error threshold mechanism on userspace will only work if userspace 
> > knows that the error belongs to the same DIMM.
> 
> Just read the first mail again:
> 
>           <idle>-0     [000] d.h. 56068.488759: extlog_mem_event: 3 corrected errors:unknown on Memriser1 CHANNEL A DIMM 0(FRU: 00000000-0000
> -0000-0000-000000000000  physical addr: 0x0000000851fe0000 node: 0 card: 0 module: 0 rank: 0 bank: 0 row: 28927 column: 1296)

On that log, "physical addr: 0x0000000851fe0000 node: 0 card: 0 module: 0 rank: 0 bank: 0 row: 28927 column: 1296"
is a string, instead of an hierarchical position, like what it is provided
on EDAC.

Worse than that, not all data may be available, as CPER allows to
ommit some data.

Also, I suspect that, if an error happens to affect more than one DIMM
(e. g. part of the location is not available for a given error),
that the DIMM label will also not be properly shown.

Also, writing the userspace counterpart that would work properly is
extremely hard, if the information about the memory layout is not known
in advance. So, in practice, if the above memory error is provided, all
userspace will likely be able to do is to store it and require someone
to manually identify what's happening.

On the other hand, if node, channel and dimm number information is
properly filled (like it happens on EDAC), usersapce can rely on those
data, in order to apply per dimm, per channel and per node thresholds.

It may even use the physical address to identify if the problem is only on
a certain region of a physical DIMM and poison that region, while it is
not possible to replace the damaged component.

Regards,
Mauro
