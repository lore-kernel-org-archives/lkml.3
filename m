Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaHMJxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:53:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12346 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaHMJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:53:21 -0400
X-IronPort-AV: E=Sophos;i="5.01,856,1400025600"; 
   d="scan'208";a="161913775"
Message-ID: <53EB358F.9040001@citrix.com>
Date: Wed, 13 Aug 2014 10:53:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com>
In-Reply-To: <1407851024-18936-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 14:43, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> bind_interdomain_evtchn_to_irq() is currently a private function. It is used
> only by bind_interdomain_evtchn_to_irqhandler() to register an irq-handler for
> an event channel.
> 
> By making it public it is possible to use e.g. threaded interrupts with
> interdomain event channels.

Acked-by: David Vrabel <david.vrabel@citrix.com>

But can you change the subject/commit message to:

    xen/events: support threaded irqs for interdomain event channels

    Export bind_interdomain_evtchn_to_irq() so drivers can use threaded
    interrupt handlers with:

     irq = bind_interdomain_evtchn_to_irq(remote_dom, remote_port);
     if (irq < 0)
         /* error */
     ret = request_threaded_irq(...);

Since your pvscsi series depends on this you will want to add this to
that series to be merged via the scsi tree.

David

