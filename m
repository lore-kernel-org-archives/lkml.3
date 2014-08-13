Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHMJzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:55:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaHMJzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:55:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,856,1400025600"; 
   d="scan'208";a="161913970"
Message-ID: <53EB35F1.6000208@citrix.com>
Date: Wed, 13 Aug 2014 10:54:57 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com> <53EB3014.8090008@citrix.com> <53EB3337.3030809@suse.com>
In-Reply-To: <53EB3337.3030809@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 10:43, Juergen Gross wrote:
> 
> static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t
> ring_ref,
>                         evtchn_port_t evtchn)
> {
> ...
>         irq = bind_interdomain_evtchn_to_irq(info->domid, evtchn);
>         request_threaded_irq(irq, NULL, scsiback_irq_fn,
>                              IRQF_ONESHOT, "vscsiif-backend", info)
> ...

This usage is fine.

I assume the error checking of bind_interdomain_evtchn_to_irq() and
request_threaded_irq() was omitted for clarity in this example?

David
