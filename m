Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab3BLXsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:48:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3BLXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:48:04 -0500
Date: Tue, 12 Feb 2013 15:48:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Message-Id: <20130212154802.186ed71a.akpm@linux-foundation.org>
In-Reply-To: <5114CE00.6050307@ozlabs.org>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
	<20130207151333.f01d415c.akpm@linux-foundation.org>
	<5114CE00.6050307@ozlabs.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 18:05:52 +0800
Jeremy Kerr <jk@ozlabs.org> wrote:

> > I'll do this for now:
> >
> > --- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
> > +++ a/tools/testing/selftests/efivarfs/Makefile
> > @@ -6,7 +6,7 @@ test_objs = open-unlink
> >   all: $(test_objs)
> >
> >   run_tests: all
> > -	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> > +	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> >
> >   clean:
> >   	rm -f $(test_objs)
> >
> > but I'm not sure I did it right :(
> 
> efivarfs.sh requires bash currently, so we'll need to call this explicitly:
> 
> +	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> 
> Is this okay?

Judging from ./Makefile:

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

bash is "optional" (this seems dumb, because all of us have
bash and we won't test /bin/sh).

But I expect that anyone who has an interest in running the selftests
is capable of making /bin/bash appear, so I'll make that change.

