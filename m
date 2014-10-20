Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaJTKgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:36:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:38188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJTKgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:36:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,755,1406617200"; 
   d="scan'208";a="621784111"
Date: Mon, 20 Oct 2014 13:35:55 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, josh.triplett@intel.com,
        christophe.ricard@gmail.com, will.c.arthur@intel.com,
        monty.wiseman@intel.com
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Message-ID: <20141020103555.GA5647@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <CALCETrUt8wK+wPULZpPQks3xEB0JkQkUD=peLSnBrMo70LT13w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUt8wK+wPULZpPQks3xEB0JkQkUD=peLSnBrMo70LT13w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 03:07:49PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 15, 2014 at 4:35 AM, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > Implemented sysfs attributes for TPM2 devices. TPM2 sysfs attributes
> > are mounted in the actual device associated with the chip instead of
> > platform device like with TPM1 devices.
> >
> > Documentation/ABI/stable/sysfs-class/tpm2 contains descriptions
> > of these attributes.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> 
> > +What:          /sys/class/misc/tpmX/device/cancel
> > +Date:          October 2014
> > +KernelVersion: 3.19
> > +Contact:       tpmdd-devel@lists.sf.net
> > +Description:   The "cancel" property allows you to cancel the currently
> > +               pending TPM command. Writing any value to cancel will call the
> > +               TPM chip specific cancel operation.
> 
> This is weird.  From the POV of a sysfs user, what operation gets
> canceled?  What if it's a kernel-internal operation?
> 
> Shouldn't this be an ioctl?

This was a really good insight, thank you. I just followed along the
lines what was defined for TPM1 but didn't think too much. This is
racy attribute and should not be added for TPM2.

I'll drop this. Adding ioctl() later would much better idea as it is
not racy but I think it should be postponed after this patch set so
that it stays digestable size.

> --Andy

/Jarkko
