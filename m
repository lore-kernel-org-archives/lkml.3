Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3GKNL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:11:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab3GKNLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:11:23 -0400
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1373545982.19894.82.camel@pasglop>
Date: Thu, 11 Jul 2013 15:11:15 +0200
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <55F96DD9-50B1-41CA-9257-FBF7DED90966@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-7-git-send-email-aik@ozlabs.ru> <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru> <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru> <1373545982.19894.82.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2013, at 14:33, Benjamin Herrenschmidt wrote:

> On Thu, 2013-07-11 at 15:12 +1000, Alexey Kardashevskiy wrote:
>>>> Any debug code is prohibited? Ok, I'll remove.
>>> 
>>> Debug code that requires code changes is prohibited, yes.
>>> Debug code that is runtime switchable (pr_debug, trace points, etc)
>>> are allowed.
> 
> Bollox.
> 
> $ grep DBG\( arch/powerpc/ -r | wc -l
> 418
> 
> Also pr_devel is not runtime switchable in normal kernels either and
> still an "official" kernel interface.
> 
>> Is there any easy way to enable just this specific udbg_printf (not all of
>> them at once)? Trace points do not work in real mode as we figured out.
> 
> The cleaner way to do it is to use some kind of local macro that you
> enable/disable by changing a #define at the top of the function, possibly
> several.

If you do that in a way that doesn't bitrot, that's acceptable, yes. Something that leaves cpp compile checks working while optimizing out the debug code.


Alex

