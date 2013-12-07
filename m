Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3LGRpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:45:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34962 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3LGRpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:45:45 -0500
Date: Sat, 7 Dec 2013 18:45:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: rui wang <ruiv.wang@gmail.com>, Lance Ortiz <lance.ortiz@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, lance_ortiz@hotmail.com,
        jiang.liu@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, gong.chen@intel.com
Subject: Re: [PATCH v10 1/3] aerdrv: Trace Event for AER
Message-ID: <20131207174542.GB4183@pd.tnic>
References: <CANVTcTYJS3eAUA4bHVCrKgz=7rQpJZHCiBcw3JM=j0FbCsgQJw@mail.gmail.com>
 <CABawtvPz5sZxhFnQru8Uc6UwF-O8HyGred_RWqBBeT615Qj8sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABawtvPz5sZxhFnQru8Uc6UwF-O8HyGred_RWqBBeT615Qj8sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:11:07PM +0800, Ethan Zhao wrote:
> > @@ -63,10 +63,10 @@ TRACE_EVENT(aer_event,
> >
> >         TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> >                 __get_str(dev_name),
> > -               __entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> > -                       __entry->severity == HW_EVENT_ERR_FATAL ?
> > +               __entry->severity == AER_CORRECTABLE ? "Corrected" :
> > +                       __entry->severity == AER_FATAL ?
> >                         "Fatal" : "Uncorrected",
> 
> Why not             "Fatal" : "Non-fatal",   ?  per the PCIe spec,
> 'Fatal' and 'Non-fatal' are sub-category of "
> Uncorrected". But here "Uncorrected" means "Non-fatal".

... and just to denote that, it'll probably be best to say:

		__entry->severity == AER_CORRECTABLE ? "Corrected" :
			__entry->severity == AER_FATAL ?
			   "Fatal" : "Uncorrected, non-fatal"

right?

Btw, Rui, you patch is whitespace-damaged so next time please try
sending from a real mail client which doesn't mangle whitespace and not
from the gmail web interface. Sending the patch to yourself and trying
to apply it is always a good test for that.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
