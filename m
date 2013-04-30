Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab3D3PPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:15:40 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:65242 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760800Ab3D3PPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:15:36 -0400
Message-ID: <517FE013.1000509@linaro.org>
Date: Tue, 30 Apr 2013 16:15:31 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST when a VIRQ
 is bound
References: <1367264377-7107-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1304301556130.5398@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1304301556130.5398@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 04:02 PM, Stefano Stabellini wrote:

> On Mon, 29 Apr 2013, Julien Grall wrote:
>> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
>> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
>> irq_startup, that is responsible for calling irq_unmask at startup time.
>> As a result event channels remain masked.
>>
>> The clear is already made in bind_evtchn_to_irq with commit a8636c0 but was
>> missing in bind_virq_to_irq.
>>
>> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> 
> As in the original commit, you should point out that this change does
> not have any effects on x86 (where IRQ_NOREQUEST and IRQ_NOAUTOEN are
> cleared by default).
> 
> At this point we might as well do this consistently everywhere we
> allocate a new evtchn irq, including pirqs and ipis, even though we don't
> actually use them on ARM.
> 
> If the call to irq_clear_status_flags can be moved earlier, a good place
> for it could be xen_irq_init.


Thanks for the review. I will give a try and send a version with it if
the solution works.

-- 
Julien
