Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3CEIJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:09:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57450 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab3CEIJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:09:12 -0500
Date: Tue, 5 Mar 2013 08:08:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Keir (Xen.org)" <keir@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Deegan <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
Message-ID: <20130305080845.GA19097@mudshark.cambridge.arm.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
 <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
 <51340ACD.70904@gmail.com>
 <20130305030436.GA18040@mudshark.cambridge.arm.com>
 <513596F2.1000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513596F2.1000701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 06:55:46AM +0000, Rob Herring wrote:
> > I also can't immediately see why GCC would allocate oldval to an odd base
> > register. Can you share your .config please?
> >
> 
> Here's a config:

[...]

Cheers Rob, that was enough to reproduce for me. The problem is likely that
CONFIG_AEABI=n, so the ABI doesn't actually mandate even base registers for
64-bit values in registers.

Ian -- this would be fixed if you used our atomic64 routines instead of
inventing your own :)

Will
