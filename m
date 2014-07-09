Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaGIQ3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaGIQ3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:29:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140709160349.GA5292@pd.tnic>
References: <20140709160349.GA5292@pd.tnic> <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: dhowells@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH 00/17] KEYS: PKCS#7 and PE file signature checking for kexec
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7856.1404923329.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jul 2014 17:28:49 +0100
Message-ID: <7857.1404923329@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

> let me see if I get this straight:
> 
> this current submission is supposed to replace
> 
> http://lkml.kernel.org/r/20140708131504.28621.61165.stgit@warthog.procyon.org.uk

Yes.  It's an extension of that.  Plus I did it wrong and managed to lose the
actual first patch, I realise.

> and Vivek's one:
> 
> http://lkml.kernel.org/r/1404421641-12691-1-git-send-email-vgoyal@redhat.com
> 
> (which added those parsers to arch/x86/kernel/ - not a good place anyway.)

Yep.

> The kexec bits with the sig verif will come ontop, it seems. What's the
> story guys?

Here's an example of what I think it could look like:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=kexec-pefile

I did the following:

 (1) Rebased all but the last of Vivek's patches onto the same base as my
     pkcs7 and pefile patches.

 (2) Substituted on of Andrew Morton's patches for one of Vivek's.

 (3) Stacked a merge of my stuff on top of Vivek's.

 (4) Stacked Vivek's final patch on top of that and fixed it to work with my
     changed stuff.

I'm leaving that to Vivek as to when he wants to push that out, though - and
whether or not he wants to push from my tree or his own.

David
