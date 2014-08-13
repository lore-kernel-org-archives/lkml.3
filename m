Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaHMKEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:04:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaHMKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:04:28 -0400
Message-ID: <53EB382A.2040800@suse.com>
Date: Wed, 13 Aug 2014 12:04:26 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com> <53EB358F.9040001@citrix.com>
In-Reply-To: <53EB358F.9040001@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 11:53 AM, David Vrabel wrote:
> On 12/08/14 14:43, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> bind_interdomain_evtchn_to_irq() is currently a private function. It is used
>> only by bind_interdomain_evtchn_to_irqhandler() to register an irq-handler for
>> an event channel.
>>
>> By making it public it is possible to use e.g. threaded interrupts with
>> interdomain event channels.
>
> Acked-by: David Vrabel <david.vrabel@citrix.com>
>
> But can you change the subject/commit message to:
>
>      xen/events: support threaded irqs for interdomain event channels
>
>      Export bind_interdomain_evtchn_to_irq() so drivers can use threaded
>      interrupt handlers with:
>
>       irq = bind_interdomain_evtchn_to_irq(remote_dom, remote_port);
>       if (irq < 0)
>           /* error */
>       ret = request_threaded_irq(...);
>
> Since your pvscsi series depends on this you will want to add this to
> that series to be merged via the scsi tree.

Already done locally. :-)


Juergen

