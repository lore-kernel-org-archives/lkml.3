Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaKXROs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:14:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57295 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKXROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:14:46 -0500
Message-ID: <1416849247.4921.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, mmarek@suse.cz,
        rusty@rustcorp.com.au, vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 12:14:07 -0500
In-Reply-To: <31431.1416845619@warthog.procyon.org.uk>
References: <14276.1416833541@warthog.procyon.org.uk>
	 <5472F806.8000403@samsung.com>
	 <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <546F3742.9010702@samsung.com> <31431.1416845619@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112417-0025-0000-0000-00000657AD8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 16:13 +0000, David Howells wrote: 
> David Howells <dhowells@redhat.com> wrote:
> 
> > > Actually after cleaning the tree and re-signing the modules, I get following
> > > 
> > > Unrecognized character \x7F; marked by <-- HERE after <-- HERE near
> > > column 1 at ./scripts/sign-file line 1.
> > > make[1]: *** [arch/x86/crypto/aes-x86_64.ko] Error 255
> > 
> > warthog>grep -r sign-file Makefile 
> > mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
> > 
> > Because of that.  I need to remove the 'perl' bit.
> 
> It's a little more involved than that.  The X.509 cert being passed to the
> program is binary, whereas the one I've been testing with is PEM encoded - and
> libssl has separate routines that don't work out for themselves which encoding
> is in force.  Proposed changes below.

With this patch, I'm now able to install and boot the new kernel and
modules.

Mimi

