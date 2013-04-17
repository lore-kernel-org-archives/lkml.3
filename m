Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032Ab3DQX5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:57:46 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49113 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3DQX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130418092444.a4d64d8a9b5f700ba2aae779@canb.auug.org.au>
References: <20130418092444.a4d64d8a9b5f700ba2aae779@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 17 Apr 2013 17:57:21 -0600
Message-ID: <CAErSpo4B0sQpozB9Zco892_wtykMQ9-P2iF4QR+HXdte1YpMzg@mail.gmail.com>
Subject: Re: PCI: Remove "extern" from function declarations
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 5:24 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bjorn,
>
> I just noticed this commit (f39d5b72913e "PCI: Remove "extern" from
> function declarations") in the pci next branch.  Just wondering why you
> would do such a thing.  It is a lot of churn in quite a few header files
> and (in my opinion) goes the wrong way anyway.
>
> It may not actually make any difference to the compiler for functions, but
> for variables, it does.   A variable declared in a header file without
> "extern" will effectively define it in every compilation that includes
> the header file, one with "extern" will only produce references.
>
> So, since, the global variables really should have the "extern", the
> functions are now inconsistent with that.
>
> It also means that when someone copies a function declaration to make a
> "static inline" stub, the "extern" is a big hint for them to remember to
> make the stub "static" - I have seen several occasions when this was not
> done and that causes compilation failures (but usually only in the
> configuration that the author did not bother to test).

Good points.  The fact that some function declarations use "extern"
and some don't is just an annoying inconsistency.  I prefer fewer
words to read, so I removed them, but that's just a personal
preference, and I'd be OK it were always present, too.  I suppose if
anybody but me actually cared very much, we'd have checkpatch complain
about one way or the other, but I don't think it does.

Bjorn
