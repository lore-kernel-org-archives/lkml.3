Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3EMJG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:06:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:54959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3EMJG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:06:56 -0400
Message-ID: <1368435991.19924.35.camel@pasglop>
Subject: Re: [RFC PATCH v3 2/5] powerpc: Exception hooks for context
 tracking subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, paulus@samba.org,
        michael@ellerman.id.au
Date: Mon, 13 May 2013 19:06:31 +1000
In-Reply-To: <1368434680.2618.33.camel@ThinkPad-T5421>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368422493-9831-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368424667.19924.26.camel@pasglop>
	 <1368434680.2618.33.camel@ThinkPad-T5421>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 16:44 +0800, Li Zhong wrote:
> Yes, the above and hash_page() are two C functions for a same exception.
> And the exception hooks enable RCU usage in those C codes. But for asm
> codes, I think we could assume that there would be no RCU usage there,
> so we don't need wrap them in the hooks.

hash_page() won't start a new RCU, at least not in its current incarnation,
the only thing I can see it ever doing would be to take some RCU read locks one
day (it doesn't today).

low_hash_fault() is a different beast. It will typically kill things, thus
involving sending signals etc... RCU might well be involved.

Cheers,
Ben.


