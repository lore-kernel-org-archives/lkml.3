Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaBEW0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:26:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:35323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbaBEW0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:26:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,789,1384329600"; 
   d="scan'208";a="450399739"
Date: Wed, 5 Feb 2014 14:23:52 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv2 08/10] xhci: Add a global command queue
Message-ID: <20140205222352.GA14117@xanatos>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
 <1391091027-31783-9-git-send-email-mathias.nyman@linux.intel.com>
 <CAPcyv4gFtrDVTE6JCLFqG4SP2SQNALNwstaULcM67Zi5RrpJ5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gFtrDVTE6JCLFqG4SP2SQNALNwstaULcM67Zi5RrpJ5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:57:09PM -0800, Dan Williams wrote:
> On Thu, Jan 30, 2014 at 6:10 AM, Mathias Nyman <mathias.nyman@linux.intel.com> wrote:
> > @@ -1722,6 +1723,12 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
> >                 kfree(cur_cd);
> >         }
> >
> > +       list_for_each_entry_safe(cur_cmd, next_cmd,
> > +                       &xhci->cmd_list, cmd_list) {
> > +               list_del(&cur_cmd->cmd_list);
> > +               kfree(cur_cmd);
> > +       }
> > +
> 
> Aren't commands on the cmd_list currently being executed, or are there
> other guarantees that make sure all commands have terminated?

By the time we get to xhci_mem_cleanup, we've done our best effort to
halt the xHCI host controller.  That could timeout, I suppose, but I'm
not sure what we're expected to do in that case.  If the host won't
halt, I'm not sure it will be able to, say, respond to the request to
cancel the current command.

Sarah Sharp
