Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaIDL0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:26:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaIDL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:26:05 -0400
Date: Thu, 4 Sep 2014 13:25:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 01/11] cpumask: factor out show_cpumap into separate
 helper function
Message-ID: <20140904112551.GC346@worktop.programming.kicks-ass.net>
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com>
 <1409763617-17074-2-git-send-email-sudeep.holla@arm.com>
 <20140904062006.GC3190@worktop.ger.corp.intel.com>
 <54082ADD.6040004@arm.com>
 <20140904092135.GA346@worktop.programming.kicks-ass.net>
 <54084246.7010705@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54084246.7010705@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:43:18AM +0100, Sudeep Holla wrote:
> >You could make it bitmap_copy_to_buf() I suppose, and then have a
> >cpumask inline wrapper, to be fully consistent with the rest of the
> >implementations.
> >
> 
> I liked the second approach, how about patch below ?
> If will munge it into original patch.

Looks good, one more nit if you will permit :-)

> +int bitmap_copy_to_pagebuf(bool list, const unsigned long *maskp, char *buf)

Maybe s/copy/print/ or something? Its not really a 'copy' as such since
it very much transforms the bitmap.
