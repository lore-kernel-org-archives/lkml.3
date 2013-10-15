Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab3JORA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:00:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab3JORAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:00:52 -0400
Date: Tue, 15 Oct 2013 19:00:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131015170039.GF7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015165435.GA2777@naverao1-tp.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:24:35PM +0530, Naveen N. Rao wrote:
> On 2013/10/11 02:32AM, Chen Gong wrote:
> > Use trace interface to elaborate all H/W error related
> > information.
> > 
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> <snip>
> > +TRACE_EVENT(extlog_mem_event,
> > +	TP_PROTO(u32 etype,
> > +		char *dimm_loc,
> > +		const uuid_le *fru_id,
> > +		char *fru_text,
> > +		u64 error_count,
> > +		u32 severity,
> > +		u64 phy_addr,
> > +		char *mem_loc),
> 
> [Adding Mauro...]
> 
> This looks very similar to the trace event I wrote a while back,
> which was similar to the one provided by ghes_edac:
> http://thread.gmane.org/gmane.linux.kernel.pci/24616
> 
> Seems to me this has the same issues we previously discussed w.r.t
> EDAC conflicts...

Right, I'm inclined to leave this trace_mc_event in ras_event.h to edac
use alone because of all those layers which don't mean whit for GHES and
eMCA error sources.

And maybe define a trace_mem_event which is shared by GHES and eMCA and
not use the edac tracepoint there not load ghes_edac on such systems
which have sufficient decoding capability in firmware.

Thoughts?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
