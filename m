Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBXSvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:51:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:26962 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:51:38 -0500
X-IronPort-AV: E=Sophos;i="4.97,536,1389744000"; 
   d="scan'208";a="103637010"
Message-ID: <530B94B7.5080602@citrix.com>
Date: Mon, 24 Feb 2014 18:51:35 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Subject: Re: [Xen-devel] [PATCH v2] xen: remove XEN_PRIVILEGED_GUEST
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>	<1392642197.13000.20.camel@x220>	<20140217144307.GB28658@localhost.localdomain>	<1392718467.30073.12.camel@x220> <1392728861.5144.10.camel@x220>
In-Reply-To: <1392728861.5144.10.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/14 13:07, Paul Bolle wrote:
> This patch removes the Kconfig symbol XEN_PRIVILEGED_GUEST which is
> used nowhere in the tree.
> 
> We do know grub2 has a script that greps kernel configuration files for
> its macro. It shouldn't do that. As Linus summarized:
>     This is a grub bug. It really is that simple. Treat it as one.
> 
> Besides, grub2's grepping for that macro is actually superfluous. See,
> that script currently contains this test (simplified):
>     grep -x CONFIG_XEN_DOM0=y $config || grep -x CONFIG_XEN_PRIVILEGED_GUEST=y $config
> 
> But since XEN_DOM0 and XEN_PRIVILEGED_GUEST are by definition equal,
> removing XEN_PRIVILEGED_GUEST cannot influence this test.
> 
> So there's no reason to not remove this symbol, like we do with all
> unused Kconfig symbols.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
