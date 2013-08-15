Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3HON0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:26:19 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:25951 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3HON0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:26:15 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-b5-520cd6f6b51e
Date: Thu, 15 Aug 2013 10:26:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130815102607.7168a930@samsung.com>
In-reply-to: <20130815093831.GA27616@pd.tnic>
References: <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic> <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic> <520B6282.6030906@linux.vnet.ibm.com>
 <20130814212211.544ee6a4@concha.lan> <20130815093831.GA27616@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/hQN1v13iCDPbfE7ZY0pRh8XnDPzaL
	D33XmCyW7+tntLi8aw6bxdl5x9ks7rc8ZbfoX9jLZLGv4wGTxZsL91gcuDy+t/axeLTsu8Xu
	sWBTqceubTuZPBbvecnk8eDQZhaPR4tbGD0+b5IL4IjisklJzcksSy3St0vgypjw6wtTQSdv
	Rfvn/4wNjIu5uhg5OCQETCRO/6/pYuQEMsUkLtxbzwZiCwksYZS4spSji5ELyO5mkjh39RYj
	SD2LgKrE3s2JIDVsAkYSrxpbWEFsEQElia+L5jKB1DMLfGCUmNU3GSwhLBAmsWdPMxOIzStg
	KDHl5nxGEJtTQFdizdpFrBALZjBL/Ng8jwniICeJrVN9IeoFJX5MvscCYjMLaEls3tbECmHL
	S2xe85Z5AqPALCRls5CUzUJStoCReRWjaGlxckFxUnqukV5xYm5xaV66XnJ+7iZGSGwU72B8
	scHqEKMAB6MSD++GDu4gIdbEsuLK3EOMEhzMSiK8U67yBAnxpiRWVqUW5ccXleakFh9iZOLg
	lGpgXNW7THLtqg1dy85rTamzjHyoIiFZmvR+I4eFTOPq1t/SBTfeFifHXRA/m6rmuOPZttX2
	Cu9X/ai9+f2XTFSD9IH1ayRERLSq/lpPaT7x5XXSee/H8e8uNtirPzglrr/Z+cv0WU+zElZG
	lKwy+n1IJKz/lNPfu6ukYq0dda5pZAuYaHaX/bDbo8RSnJFoqMVcVJwIACoLvjNrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 15 Aug 2013 11:38:31 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Wed, Aug 14, 2013 at 09:22:11PM -0300, Mauro Carvalho Chehab wrote:
> > 	1) EDAC core needs to know that it should reject "hardware first"
> > drivers.
> 
> -ENOPARSE. What do you mean?

I mean that the edac core needs to know that, on a given system, the
BIOS is accessing the hardware registers and sending the data via ghes_edac.

On such case, it should reject the driver that reads such data directly
from the hardware, as having both active cause inconsistent error reports
(I got a few BZ reports about that).

> >  3) If BIOS vendors add later some solution to enumerate the DIMMS
> > per memory controller, channel, socket with APEI, the addition to the
> > existing driver would be trivial.
> 
> Actually, with BIOS vendors wanting to do firmware-first strategy with
> DRAM errors, they must have a pretty good and intimate picture of the
> memory topology at hand. So it is only a logical consequence for them,
> when reporting a memory error to the OS to tell us the silkscreen label
> too, while at it.
> 
> And if they do that, we don't need the additional layer - just a
> tracepoint from APEI and a userspace script.

No. As we want that fatal errors to also be properly reported, the
kernel will still need to know the memory layout.

Ok, such information can come via userspace, just like we do with the
other EDAC drivers, but we'll need to allow to dynamically create the
memory layout via sysfs (or to use some other interface for loading that
data).

> It's a whole another question if they don't do that.

-- 

Cheers,
Mauro
