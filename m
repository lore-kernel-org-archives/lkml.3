Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3HLLeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:34:07 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:39025 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3HLLeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:34:04 -0400
X-AuditID: cbfec372-b7f046d000001821-28-5208c82a20b3
Date: Mon, 12 Aug 2013 08:33:55 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130812083355.47c1bae8@samsung.com>
In-reply-to: <20130810180322.GC4155@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/hIF2tExxBBi+nqFgsacqw+LzhH5vF
	h75rTBbL9/UzWlzeNYfN4uy842wW91ueslv0L+xlstjX8YDJ4s2FeywOXB7fW/tYPFr23WL3
	WLCp1GPXtp1MHov3vGTyeHBoM4vHo8UtjB6fN8kFcERx2aSk5mSWpRbp2yVwZew9/Zul4DFH
	xbSOeWwNjL/Zuhg5OSQETCRWTWhnh7DFJC7cWw8U5+IQEljCKNF+aiIzhNPDJDG/p40ZpIpF
	QFWir6sBzGYTMJJ41djCCmKLCChJfF00lwmkgVngA6PErL7JYAlhgTCJPXuamUBsXgFDiZ73
	EIM4BXQkWo8cYYLYcJdR4sqFzUB3cADd4SSxdaovRL2gxI/J91hAbGYBLYnN25pYIWx5ic1r
	3jJPYBSYhaRsFpKyWUjKFjAyr2IULS1OLihOSs811CtOzC0uzUvXS87P3cQIiZCiHYzPNlgd
	YhTgYFTi4fX4wh4kxJpYVlyZe4hRgoNZSYRXbR5HkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG
	DqtpT/2KPRWzHpbnXot+tuDnnfakHTzrZzpNZI9MLY8o5WL892N54x/LTfkKjF+lle9N0n68
	fOKdldUPQsUTX7i1SAZvCooI8yx6/bDG/1CLnITlslkGuvyli57xBrnM+DH3AnO5vLvCT9Ut
	ucXxH3l0bbe9jDX8JD3ROSjXWP7t4uucW2KVWIozEg21mIuKEwHoHbKObgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 10 Aug 2013 20:03:22 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Aug 08, 2013 at 04:38:22PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 08 Aug 2013 23:57:51 +0530
> > "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:
> > 
> > > Enable memory error trace event in cper.c
> > 
> > Why do we need to do that? Memory error events are already handled
> > via edac_ghes module,
> 
> If APEI gives me all the required information in order to deal with the
> hardware error - and it looks like it does - then the additional layer
> of ghes_edac is not needed.

APEI is just the mechanism that collects the data, not the mechanism
that reports to userspace.

The current implementation is that APEI already reports those errors
via ghes_edac driver. It also reports the very same error via MCE
(although the APEI interface to MCE is currently broken for everything
that it is not Nehalem-EX - as it basically emulates the MCE log for
that specific architecture).

I really don't see any sense on adding yet-another-way to report the
very same error.

Regards,
Mauro
