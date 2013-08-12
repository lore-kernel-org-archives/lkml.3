Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3HLOtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:49:43 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:10388 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3HLOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:49:41 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-ea-5208f603b3a7
Date: Mon, 12 Aug 2013 11:49:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130812114932.52bb0314@samsung.com>
In-reply-to: <20130812123813.GD18018@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/hQF3mbxxBBn3bVCyWNGVYfN7wj83i
	Q981Jovl+/oZLS7vmsNmcXbecTaL+y1P2S36F/YyWezreMBk8ebCPRYHLo/vrX0sHi37brF7
	LNhU6rFr204mj8V7XjJ5PDi0mcXj0eIWRo/Pm+QCOKK4bFJSczLLUov07RK4Ms6/28NYsIiz
	4vh9/wbG2exdjJwcEgImEnPP7mGEsMUkLtxbzwZiCwksYZRo+8vUxcgFZHczSay4dwOsiEVA
	VWLh4edgRWwCRhKvGltYQWwRASWJr4vmgjUwC3xglJjVNxksISwQJrFnTzMTiM0rYCix88VG
	sEGcAroSzw+tZoXYsIxJ4sOuZUAncQCd4SSxdaovRL2gxI/J91hAbGYBLYnN25pYIWx5ic1r
	3jJPYBSYhaRsFpKyWUjKFjAyr2IULS1OLihOSs810itOzC0uzUvXS87P3cQIiY7iHYwvNlgd
	YhTgYFTi4c34yBEkxJpYVlyZe4hRgoNZSYRXbR5QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6O9
	H+vzt6t273jSoGDhsa+Z/WnwTb8Lwn385cwHWdns55R9KSnZZfyhLE576af8OIMMD/c7q5iW
	MevyCsuktl66bbD08omPixs+Pk+/9fNrl6qkiELXNOtzH0x1IzJWMmZX7+zMM7tmMHHDni9z
	dOf0pP1Wd78u4bQnKNZ+6XqtbW5M7fXX+ZRYijMSDbWYi4oTARvRzYNsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 12 Aug 2013 14:38:13 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Aug 12, 2013 at 08:33:55AM -0300, Mauro Carvalho Chehab wrote:
> > APEI is just the mechanism that collects the data, not the mechanism
> > that reports to userspace.
> 
> Both methods add a tracepoint - no difference.
> 
> > I really don't see any sense on adding yet-another-way to report the
> > very same error.
> 
> Well, your suggested way through the layers is this:
> 
> Hardware->APEI->EDAC.
> 
> His is
> 
> Hardware->APEI.
> 
> If I can lose the EDAC layer, then this is a clear win.

Clear win from what PoV? Userspace will need to decode a different type
of tracing, and implement a different logic for APEI. So, it will be
reinventing the wheel, with a different trace format, and will require
userspace to implement another tracing event for the same thing that
EDAC already provides.

Also, if both ghes_edac and this new tracing is enabled, userspace will
receive twice the same event, as two traces will be received for the
same thing.

Worse than that, how userspace is supposed to merge those two events
into one?
> 


-- 

Cheers,
Mauro
