Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbaGSJSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:18:08 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:38682 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaGSJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <13161.1405626953@warthog.procyon.org.uk>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
	<acdd27e3b559b0c1bc57a9393e4e5540a90bab36.1405094060.git.d.kasatkin@samsung.com>
	<13161.1405626953@warthog.procyon.org.uk>
Date: Sat, 19 Jul 2014 12:18:01 +0300
Message-ID: <CACE9dm-OWJCdEfMFAjGx1qOOK17evOSvcDUcw451XUnZiY6gcQ@mail.gmail.com>
Subject: Re: Making the asymmetric keys config option into a top-level option
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:55 PM, David Howells <dhowells@redhat.com> wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> When ASYMMETRIC_KEYS=y, but depends on CRYPTO=m, selections will be also modules.
>> In random config case OID_REGISTRY, MPILIB and ASN1 became modules producing build
>> break. This patch removes asymmetric keys dependency from CRYPTO, but instead
>> selects CRYPTO and CRYPTO_HASH as they are needed.
>
> You do realise that this makes the asymmetric key config option into a
> top-level option?  I think, logically, that's the wrong thing to do.  They
> should still appear under the crypto menu.
>

Oops, this is not what I wanted to have.
Yes, I wanted to have still them under crypto but wanted to break dependency.
I was hurrying before starting the holidays, tested only from command line,
but did not look to menuconfig.

In overall asymmetric keys does not provide any crypto API.
Instead they provide key types... They use crypto api them in couple of places.
So it is more about "selecting" crypto.
In my opinion "entire" location of asymmetric keys under /crypto is wrong.
RSA algo may be there, but reset of the stuff can be under /keys.

-Dmitry

> Note that I think your patch is really the wrong solution.  The right solution
> is to fix the configuration tools - but that's quite an undertaking.
>
> David
