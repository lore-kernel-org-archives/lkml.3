Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaH1PuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:50:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9385 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaH1PuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:50:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406592000"; 
   d="scan'208";a="166830349"
Message-ID: <53FF4FA5.4050105@citrix.com>
Date: Thu, 28 Aug 2014 16:49:57 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/evtchn.c: Check failure for evtchn_make_refcounted()
References: <53FF4702.9020509@gmail.com>
In-Reply-To: <53FF4702.9020509@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/14 16:13, Chen Gang wrote:
> evtchn_make_refcounted() may return failure, so need process the failure
> case. In failure case, it need call unbind_from_irqhandler() just like
> evtchn_unbind_from_user() has done.
> 
> irq_from_evtchn() must be OK when bind_evtchn_to_irqhandler() succeed,
> so need not check it again.
> 
> Also still need remain the closing port code, because when the failure
> occurs, unbind_from_irqhandler() will not close port internally.

None of the evtchn_make_refcounted() failures can occur since we know we
have a valid irq and info at the single call site.

I would like to see this fixed by refactoring the code to remove
evtchn_make_refcounted() by making all irqs for event channels reference
counted.  These no need for this refcounting to be optional.

David

