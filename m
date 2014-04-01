Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaDAMxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:53:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25978 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaDAMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:53:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,772,1389744000"; 
   d="scan'208";a="115670416"
Message-ID: <533AB6D4.2050807@citrix.com>
Date: Tue, 1 Apr 2014 13:53:40 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <Ian.Campbell@citrix.com>,
        <JBeulich@suse.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>	<1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>	<528E485C.5030906@citrix.com>	<20131126165016.GH2959@phenom.dumpdata.com>	<529C7205.3060406@citrix.com> <20140331203313.GA6756@phenom.dumpdata.com>
In-Reply-To: <20140331203313.GA6756@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/14 21:33, Konrad Rzeszutek Wilk wrote:
> 
> Subject: [PATCH] xen/xenbus: Avoid synchronous wait on XenBus stalling
>  shutdown/restart.
> 
> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> 'process_msg' is running from within the 'xenbus' thread. Whenever
> a message shows up in XenBus it is put on a xs_state.reply_list list
> and 'read_reply' picks it up.
> 
> The problem is if the backend domain or the xenstored process is killed.
> In which case 'xenbus' is still awaiting - and 'read_reply' if called -
> stuck forever waiting for the reply_list to have some contents.
> 
> This is normally not a problem - as the backend domain can come back
> or the xenstored process can be restarted. However if the domain
> is in process of being powered off/restarted/halted - there is no
> point of waiting on it coming back - as we are effectively being
> terminated and should not impede the progress.
> 
> This patch solves this problem by checking whether the guest is
> the right domain. If it is an initial domain and hurtling towards
> death - there is no point of continuing the wait. All other type
> of guests continue with their behavior.
> mechanism a bit more asynchronous.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
