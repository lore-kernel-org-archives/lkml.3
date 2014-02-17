Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaBQOnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:43:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaBQOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:43:40 -0500
Date: Mon, 17 Feb 2014 09:43:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: remove XEN_PRIVILEGED_GUEST
Message-ID: <20140217144307.GB28658@localhost.localdomain>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
 <1392642197.13000.20.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392642197.13000.20.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:03:17PM +0100, Paul Bolle wrote:
> On Mon, 2014-02-17 at 07:23 -0500, Konrad Rzeszutek Wilk wrote:
> > On Feb 16, 2014 3:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Please look in the grub git tree. They have fixed their code to not do
> > this anymore. This should be reflected in the patch description.
> 
> Thanks, I didn't know that. That turned out to be grub commit
> ec824e0f2a399ce2ab3a2e3353d372a236595059 ("Implement grub_file tool and
> use it to implement generating of config"), see
> http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=ec824e0f2a399ce2ab3a2e3353d372a236595059
> 
> > Lastly please check which distro has this new grub version so that we
> > know which distros won't be affected.
> 
> No distro should be affected. See, the test that grub2 used to do was
> (edited for clarity):
>     grep -qx "CONFIG_XEN_DOM0=y" "${config}" || grep -qx "CONFIG_XEN_PRIVILEGED_GUEST=y" "${config}"
> 
> But the Kconfig entry for XEN_PRIVILEGED_GUEST reads:
>     config XEN_PRIVILEGED_GUEST
>             def_bool XEN_DOM0
> 
> Ie, XEN_PRIVILEGED_GUEST is equal to XEN_DOM0 by definition, so the
> second part of that test is superfluous. (We discussed this last year.
> If lkml.org weren't down I'd provide a link.) Or am I misreading this
> Kconfig entry?

Ah, forgot about the second test for 'XEN_DOM0'. Yes that should work.

Thanks!
> 
> I hope to send a v2, with an updated commit explanation, in a few days.
> 
> 
> Paul Bolle
> 
