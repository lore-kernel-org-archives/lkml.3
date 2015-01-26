Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbbAZXPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:15:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:6384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbbAZXPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:15:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,471,1418112000"; 
   d="scan'208";a="676269170"
Message-ID: <1422314099.5801.1.camel@theros.lm.intel.com>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory
 instructions
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Jan 2015 16:14:59 -0700
In-Reply-To: <20150126223954.GJ1656@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
	 <54C2D34D.7010709@intel.com> <20150124111430.GA10084@pd.tnic>
	 <1422302369.13382.3.camel@theros.lm.intel.com>
	 <20150126213457.GI1656@pd.tnic>
	 <1422309007.14456.1.camel@theros.lm.intel.com>
	 <20150126223954.GJ1656@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 23:39 +0100, Borislav Petkov wrote:
> On Mon, Jan 26, 2015 at 02:50:07PM -0700, Ross Zwisler wrote:
> > We can use MFENCE, but I don't think we need to. With SFENCE we will
> > be ordered with respect to stores, and the flushes and pcommit will be
> > ordered with respect to one another. I think you can sprinkle in loads
> > anywhere you want in that flow and everything will work.
> 
> 
> Ok, maybe we should hold down that sequence and this somewhere as a
> this-is-how-you-should-do-pcommit-properly explanation or so... or do
> you have an actual patch adding write_and_commit_buffer()?

I don't have a patch to add and use this yet.  I'll add the flow to the
commit messages for both pcommit and clwb.

