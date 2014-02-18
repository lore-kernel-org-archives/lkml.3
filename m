Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaBRNOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:14:01 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63142 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157AbaBRNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:14:00 -0500
Message-ID: <1392729238.5144.14.camel@x220>
Subject: Re: [PATCH v2] xen: remove XEN_PRIVILEGED_GUEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 14:13:58 +0100
In-Reply-To: <1392728861.5144.10.camel@x220>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
	 <1392642197.13000.20.camel@x220>
	 <20140217144307.GB28658@localhost.localdomain>
	 <1392718467.30073.12.camel@x220> <1392728861.5144.10.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2014 13:13:58.0607 (UTC) FILETIME=[48994DF0:01CF2CAB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here I should have added:

From:  Michael Opdenacker <michael.opdenacker@free-electrons.com>

in order for Michael to show up as author of the patch. 

On Tue, 2014-02-18 at 14:07 +0100, Paul Bolle wrote:
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
> 
> [pebolle@tiscali.nl: rewrote commit explanation.]
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle

