Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3EMJqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:46:38 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43511 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3EMJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:46:35 -0400
Message-ID: <1368438380.2618.52.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v3 2/5] powerpc: Exception hooks for context
 tracking subsystem
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, paulus@samba.org,
        michael@ellerman.id.au
Date: Mon, 13 May 2013 17:46:20 +0800
In-Reply-To: <1368435991.19924.35.camel@pasglop>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368422493-9831-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368424667.19924.26.camel@pasglop>
	 <1368434680.2618.33.camel@ThinkPad-T5421>
	 <1368435991.19924.35.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051309-1396-0000-0000-000002F5C600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 19:06 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-13 at 16:44 +0800, Li Zhong wrote:
> > Yes, the above and hash_page() are two C functions for a same exception.
> > And the exception hooks enable RCU usage in those C codes. But for asm
> > codes, I think we could assume that there would be no RCU usage there,
> > so we don't need wrap them in the hooks.
> 
> hash_page() won't start a new RCU, at least not in its current incarnation,
> the only thing I can see it ever doing would be to take some RCU read locks one
> day (it doesn't today).

Seems I added the hooks because of the trace point of hcall
entry/exit ...

Thanks, Zhong

> 
> low_hash_fault() is a different beast. It will typically kill things, thus
> involving sending signals etc... RCU might well be involved.
> 
> Cheers,
> Ben.
> 
> 


