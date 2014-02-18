Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaBRKOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:14:32 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:57295 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbaBRKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:14:29 -0500
Message-ID: <1392718467.30073.12.camel@x220>
Subject: Re: [PATCH] xen: remove XEN_PRIVILEGED_GUEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 11:14:27 +0100
In-Reply-To: <20140217144307.GB28658@localhost.localdomain>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
	 <1392642197.13000.20.camel@x220>
	 <20140217144307.GB28658@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2014 10:14:27.0593 (UTC) FILETIME=[3492FF90:01CF2C92]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 09:43 -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 17, 2014 at 02:03:17PM +0100, Paul Bolle wrote:
> > On Mon, 2014-02-17 at 07:23 -0500, Konrad Rzeszutek Wilk wrote:
> > > On Feb 16, 2014 3:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > Please look in the grub git tree. They have fixed their code to not do
> > > this anymore. This should be reflected in the patch description.
> > 
> > Thanks, I didn't know that. That turned out to be grub commit
> > ec824e0f2a399ce2ab3a2e3353d372a236595059 ("Implement grub_file tool and
> > use it to implement generating of config"), see
> > http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=ec824e0f2a399ce2ab3a2e3353d372a236595059

And that commit was reverted a week later in grub commit
faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 ("Revert grub-file usage in
grub-mkconfig."), see
http://git.savannah.gnu.org/cgit/grub.git/commit/util/grub.d/20_linux_xen.in?id=faf4a65e1e1ce1d822d251c1e4b53d96ec7faec5 .

That commit has no explanation (other than its one line summary). So
we're left guessing why this was done. Luckily, it doesn't matter here,
because the test for CONFIG_XEN_PRIVILEGED_GUEST is superfluous.

Anyhow, I hope to submit a second version of this patch later this day.


Paul Bolle

