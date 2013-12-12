Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3LLVbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:31:52 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:62949 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3LLVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:31:47 -0500
MIME-Version: 1.0
In-Reply-To: <4197.1386708027@warthog.procyon.org.uk>
References: <4197.1386708027@warthog.procyon.org.uk>
Date: Thu, 12 Dec 2013 13:31:46 -0800
X-Google-Sender-Auth: fkcypFMZ3QNDLbBETJcf-qFbXI0
Message-ID: <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com>
Subject: Re: [GIT PULL] KEYS: Miscellaneous fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:40 PM, David Howells <dhowells@redhat.com> wrote:
>
> Could you pull the following fixes for the keyring stuff.

Pulled. However, I notice that the following issue remains with module
key signing, and I *think* it was introduced in the -rc1 pull:

 - start with clean kernel sources

 - build kernel ("make -j16" or whatever after doing your config)

 - build kernel again ("make -j" - nothing has changed):

   ...
   X.509 certificate list changed
     CERTS   kernel/x509_certificate_list
     - Including cert /home/torvalds/v2.6/linux/signing_key.x509
     AS      kernel/system_certificates.o
     LD      kernel/built-in.o
   ...

   which causes it to relink the kernel.

 - build kernel yet again, and now finally it doesn't build/link anything.

So some rule for the certificate list seems to be broken. I'm pretty
sure this didn't happen in 3.12. Any ideas?

                 Linus
