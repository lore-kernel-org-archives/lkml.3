Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3KDGvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:51:52 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63012 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3KDGvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:51:51 -0500
Date: Mon, 4 Nov 2013 07:51:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131104065147.GB13030@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131103101825.GA6605@gmail.com>
 <20131103102132.GA6807@gmail.com>
 <20131103155729.GB9944@hansolo.jdub.homelinux.org>
 <52768B48.5030408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52768B48.5030408@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/03/2013 07:57 AM, Josh Boyer wrote:
> > 
> > OK, that makes sense.  So in this scenario, we could probably either:
> > 
> > a) do away with MAXSMP entirely and just depend on
> > CONFIG_CPUMASK_OFFSTACK.
> > 
> > b) make MAXSMP something even higher than 4096.  Like 5120 or 6144, etc.
> > 
> > Which would you prefer?  Either is easy enough to code up, I just need
> > to know which I should shoot for.
> > 
> 
> Let's get rid of MAXSMP.

I'd rather not, because it has caught a number of regressions in the past, 
because randconfig can wander over it and trigger those large configs.

randconfig will not randomize numeric Kconfig ranges, so there's no other 
mechanism right now to trigger those large config kernels.

Thanks,

	Ingo
