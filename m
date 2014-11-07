Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKGIsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:48:47 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63616 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbaKGIsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:48:46 -0500
Message-ID: <1415350123.4390.43.camel@x220>
Subject: Re: powerpc/8xx: Remove Kconfig symbol FADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Scott Wood <scottwood@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Nov 2014 09:48:43 +0100
In-Reply-To: <20141107035008.GA25204@home.buserror.net>
References: <1411545979.19525.5.camel@x220>
	 <20141107035008.GA25204@home.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2014 08:48:44.0702 (UTC) FILETIME=[A3669BE0:01CFFA67]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 21:50 -0600, Scott Wood wrote:
> On Wed, Sep 24, 2014 at 10:06:19AM +0200, Paul Bolle wrote: 
> > Another cleanup might be to remove MPC8XXFADS (or "FADS") from the "8xx
> > Machine Type" choice. Is there any reason left to pick "FADS" as a
> > machine type?
> 
> Nothing references MPC8XXFADS, so yes, it can be removed.

I'll try to look into this. For the (verbose) reasons below I'll do that
in a separate patch, if I ever get that far. What follows is mostly a
note to self.

MPC8XXFADS is indeed not referenced anywhere. But it's one of the
entries in the "8xx Machine Type" choice. And it's common for choice
blocks the have a "none of the above" entry. Ie, an entry that allows to
configure nothing. There's a chance MPC8XXFADS is currently used for
that role. (This is easier to determine for people that - unlike me -
know what all the symbols in this choice mean. To me they 're basically
random strings.)

Actually, there's an obscure "optional" Kconfig keyword that appears to
be added to take care of this use case. It's currently used exactly
twice in the tree, in smaller architectures: once in arch/avr32/ and
once in arch/sh/. This implies this "optional" keyword is used very
little. I'll have to look carefully to see whether it works as
advertised.


Paul Bolle

