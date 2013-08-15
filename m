Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3HOOOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:14:17 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:9321 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab3HOOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:14:15 -0400
X-AuditID: cbfec372-b7f046d000001821-32-520ce236f20c
Date: Thu, 15 Aug 2013 11:14:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130815111407.4080a744@samsung.com>
In-reply-to: <20130815134454.GF27616@pd.tnic>
References: <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic> <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic> <520B6282.6030906@linux.vnet.ibm.com>
 <20130814212211.544ee6a4@concha.lan> <20130815093831.GA27616@pd.tnic>
 <20130815102607.7168a930@samsung.com> <20130815134454.GF27616@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/hYF2zRzxBBn/esVgsacqw+LzhH5vF
	h75rTBbL9/UzWlzeNYfN4uy842wW91ueslv0L+xlstjX8YDJ4s2FeywOXB7fW/tYPFr23WL3
	WLCp1GPXtp1MHov3vGTyeHBoM4vHo8UtjB6fN8kFcERx2aSk5mSWpRbp2yVwZaz8+YStYI14
	xcMnv9kbGDcLdTFyckgImEjse9rODmGLSVy4t54NxBYSWMIosfNEeRcjF5DdzSTx8eJJsASL
	gKrExOaVLCA2m4CRxKvGFlYQW0RASeLrorlMIA3MAh8YJWb1TQZLCAuESezZ08wEYvMKGEo0
	HV8KNIiDg1NAV2LDlAKIBTOZJbYuXsEKEpcQcJLYOtUXolxQ4sfke2C7mAW0JDZva2KFsOUl
	Nq95yzyBUWAWkrJZSMpmISlbwMi8ilG0tDi5oDgpPddQrzgxt7g0L10vOT93EyMkOop2MD7b
	YHWIUYCDUYmHN6KNO0iINbGsuDL3EKMEB7OSCO/XezxBQrwpiZVVqUX58UWlOanFhxiZODil
	Ghg7N4s8eBx7qGVZ5SQr3vSomCTGt1MTPPb97+tgmPpZrMJ5b53hmhofrUM3v2yT/fkr8rLf
	3A33XsyMtz610NhHmE18luz8uAwm2Xluk3VkjjLs/KjcYMR9R61m2pxZuwXaTdQ2nH3x3+nD
	5HmLopO27pczawwzbmKJYDJ1+D3pdeayDUf2Pw5VYinOSDTUYi4qTgQA1S9i9GwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 15 Aug 2013 15:44:54 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Aug 15, 2013 at 10:26:07AM -0300, Mauro Carvalho Chehab wrote:
> > I mean that the edac core needs to know that, on a given system, the
> > BIOS is accessing the hardware registers and sending the data via
> > ghes_edac.
> 
> Right, that's the firmware-first thing which Naveen did - see
> mce_disable_bank.
> 
> > No. As we want that fatal errors to also be properly reported, the
> > kernel will still need to know the memory layout.
> 
> Read what I said: if you have the silkscreen label you don't need the
> memory layout - you *already* *know* which DIMM is affected.

AFAIKT, APEI doesn't provide the silkscreen label. Some code (or some
datasheet) is needed to translate between what APEI provides into the
silkscreen label.

Naveen, please correct me if I'm wrong.

> Also, fatal errors are a whole different beast where we run in NMI
> context or we even don't get to run the #MC handler on some systems.

I see.

Yes, APEI currently prints only a raw event on high severity errors
at ghes_notify_nmi(), and doesn't call ghes_edac. Changing it would
require to parse the error at __ghes_print_estatus(). Not sure how
easy would be to change that.

Em Thu, 15 Aug 2013 15:51:06 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Aug 15, 2013 at 10:34:21AM -0300, Mauro Carvalho Chehab wrote:
> > Yes, but the thing is that it is not safe to use the hardware driver
> > if the BIOS is also reading the hardware error registers directly, as,
> > on several hardware, a read cause the error data to be cleaned on such
> > register.
> 
> Here's the deal:
> 
> * We parse some APEI table and disable those MCA banks which the BIOS
> wants to handle first.
> 
> * When the BIOS decides to report an error from that handling, it does
> so over another BIOS table.

OK.

> 
> * Now you have two possibilities:
> 
> ** On systems without an edac driver or where it doesn't make sense to
> have the ghes_edac driver, we call trace_mc_event() straight from APEI
> code (this is what we're currently discussung).
> 
> ** On other systems, where we need ghes_edac, we *don't* use the
> trace_mc_event() tracepoint in the APEI code but let it come from
> ghes_edac with additional information collected by edac.

I don't see why should we have those two alternatives, as, at worse
case (e. g. if ghes_edac can't enrich the APEI data with labels),
they'll basically provide the very same data to userspace, and the
EDAC extra overhead is small, on its error report logic.

The risk of doing the very same thing on two different places is that
the logic to encapsulate APEI data into trace_mc_event() would be
on two separate places. It risks that someone would change one of the
drivers and forget to apply the very same change on the other, causing
parse errors on userspace, depending on the source.

-- 

Cheers,
Mauro
