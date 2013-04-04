Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464Ab3DDSa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:30:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39775 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760994Ab3DDSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:30:57 -0400
Date: Thu, 4 Apr 2013 11:30:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 06/20] x86, ACPI: Store override acpi tables phys addr
 in cpio files info array
Message-ID: <20130404183047.GV9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-7-git-send-email-yinghai@kernel.org>
 <20130404182742.GU9425@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404182742.GU9425@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:27:42AM -0700, Tejun Heo wrote:
> > +		/*
> > +		 * have to use unsigned long, otherwise 32bit spit warning
> > +		 * and it is ok to unsigned long, as bootloader would not
> > +		 * load initrd above 4G for 32bit kernel.
> > +		 */
> > +		unsigned long addr = (unsigned long)acpi_initrd_files[no].data;
> 
> I can't say I like this.  It's stuffing phys_addr_t into void *.  It
> might work okay but the code is a bit misleading / confusing.  "void
> *" shouldn't contain a physical address.  Maybe the alternatives are
> uglier, I don't know.  If you can think of a reasonable way to not do
> this, it would be great.

Also the comment contradicts with what you wrote in the next patch.

  Boot loader could load initrd above max_low_pfn.

Hmmm?

-- 
tejun
