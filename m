Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaIBO4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:56:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:34407 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaIBO4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:56:42 -0400
Date: Wed, 3 Sep 2014 00:56:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KEYS: Miscellaneous fixes
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1409030056130.7126@namei.org>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, David Howells wrote:

> 
> Hi James,
> 
> Here are some fixes to go upstream:


Which of these need to go into current Linus?

#4 looks like it should.

> 
>  (1) Increase root's key quotas so that the DNS resolver doesn't run out of
>      capacity.  This is a bit of a stop-gap whilst I try to improve quota
>      recycling, but that's proving to be a bit tricky.
> 
>  (2) Fix the definition of the public_key subtype to give the name length.
> 
>  (3) Set a prefix for printing from signature handling.
> 
>  (4) Fix a use after free in assoc_array_gc().
> 
>  (5) Relax a check in the PKCS#7 parser to allow for padding inserted after a
>      PKCS#7 message.
> 
> They can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-fixes
> 
> Tagged with:
> 
> 	keys-fixes-20140902
> 
> David
> ---
> David Howells (4):
>       KEYS: Fix public_key asymmetric key subtype name
>       KEYS: Set pr_fmt() in asymmetric key signature handling
>       KEYS: Fix use-after-free in assoc_array_gc()
>       PEFILE: Relax the check on the length of the PKCS#7 cert
> 
> Steve Dickson (1):
>       KEYS: Increase root_maxkeys and root_maxbytes sizes
> 
> 
>  crypto/asymmetric_keys/public_key.c    |    1 +
>  crypto/asymmetric_keys/signature.c     |    1 +
>  crypto/asymmetric_keys/verify_pefile.c |   49 ++++++++++++++++++++++----------
>  lib/assoc_array.c                      |    2 +
>  security/keys/key.c                    |    4 +--
>  5 files changed, 38 insertions(+), 19 deletions(-)
> 

-- 
James Morris
<jmorris@namei.org>

