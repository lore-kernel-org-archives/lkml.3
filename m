Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3E0XaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 19:30:13 -0400
Received: from ozlabs.org ([203.10.76.45]:41482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab3E0XaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 19:30:12 -0400
From: Michael Neuling <mikey@neuling.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc, perf: Ignore separate BHRB privilege state filter request
In-reply-to: <51A32F1F.5020109@linux.vnet.ibm.com>
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com> <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com> <1369206855.12874.9.camel@concordia> <519C88D9.30009@linux.vnet.ibm.com> <51A32F1F.5020109@linux.vnet.ibm.com>
Comments: In-reply-to Anshuman Khandual <khandual@linux.vnet.ibm.com>
   message dated "Mon, 27 May 2013 15:32:07 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 28 May 2013 09:30:10 +1000
Message-ID: <2684.1369697410@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:

> On 05/22/2013 02:29 PM, Anshuman Khandual wrote:
> >>
> >> Your description from patch 0 should be here.
> > Does it sound better ?
> > 
> >>
> >>> -	if ((br_privilege != 7) && (br_privilege != 0))
> >>> -		return -1;
> >>> +
> >>> +	if (br_privilege)
> >>> +		pr_info("BHRB privilege state filter request %llx ignored\n",
> >>> +								br_privilege);
> >>
> >> Don't do that. Ignoring the br_privilege is either the right thing to do
> >> in which case we do it and print nothing,
> > 
> > 
> > I thought the informational print would at least make the user aware
> > of the fact that the separate filter request for BHRB went ignored.
> > Can we add this some where in the documentation ?
> 
> So, what we decide here ? We will just ignore any separate BHRB
> privilege state filter request without printing any informational
> event or warning ?

Printing it on the console is pointless.  No one will read it.  

If it's doing the filtering, then just drop the printk.  

	/* BHRB and regular PMU events share the same privilege state
	 * filter configuration. BHRB is always recorded along with a
	 * regular PMU event. As the privilege state filter is handled
	 * in the basic PMC configuration of the accompanying regular
	 * PMU event, we ignore any separate BHRB specific request.
	 */

That updated comment I think make it clear.  

So drop the printk and add the comment, and it's OK with me.

Mikey
