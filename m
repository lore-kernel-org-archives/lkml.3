Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3HMMnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:43:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48149 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab3HMMnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:43:01 -0400
Date: Tue, 13 Aug 2013 14:42:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130813124258.GC4077@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <520A16BD.30201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:51:33PM +0530, Naveen N. Rao wrote:
> You're right - my trace point makes all the data provided by apei
> as-is to userspace. However, ghes_edac seems to squash some of this
> data into a string when reporting through mc_event.

Right, for systems which don't need EDAC to decode to the DIMM or for
which there are no EDAC drivers written, they could use a tracepoint
which carries APEI info as-is. Others, which need EDAC, should probably
use trace_mc_event and disable the APEI tracepoint.

I think this should address Tony's concerns...

Btw, you could call your TP something simpler like
trace_ghes_memory_event or so.

Btw 2, if GHES can report other types of errors (I'm pretty sure it can)
maybe we can use a single tracepoint called trace_ghes_event for any
types of errors coming out of it...

Oh, and while at it, we probably need to start thinking of a mechanism
to disable all the error printing, i.e. cper_print_mem() and such,
if a userspace agent is listening in on the tracepoint and the error
information is carried through it to userspace.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
