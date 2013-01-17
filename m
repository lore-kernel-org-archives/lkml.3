Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3AQSD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:03:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3AQSD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:03:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358365541.4593.190.camel@falcor1>
References: <1358365541.4593.190.camel@falcor1> <cover.1358246017.git.dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] ima/evm: signature verification support using asymmetric keys
Date: Thu, 17 Jan 2013 18:03:49 +0000
Message-ID: <27882.1358445829@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> David, are you ok with how support for asymmetric keys is being added to
> EVM/IMA-appraisal for verifying signatures?  Any comments?

I would also like to have a look at altering your trusted key type[*] to be a
subtype of asymmetric keys so that the asymmetric key type can cover keys from
more sources:

	- Compiled-in keys.
	- Keys from UEFI db.
	- Keys from TPM (ie. the trusted key stuff).
	- Keys loaded by the administrator _if_ they are validated by a key the
	  kernel already has.
	
[*] I believe that that's your asymmetric key type and that your encrypted key
    type is your symmetric key type.

To support this, it may be necessary to make it possible to make the "trusted"
key type name a synonym of the "asymmetric" key type name in some way.

I also have some patches to divorce the module signing public keyring stuff
from module signing and make it a more generic system keyring of trusted keys
that can be used for other purposes (such as IMA and verifying additional
keys) that I shall post shortly.

On top of those patches, I have a series of patches to permit extra keys to be
added from signed PE binaries that can be found here:

http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel-pekey

David
