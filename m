Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaGIQWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:22:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbaGIQWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:22:37 -0400
Date: Wed, 9 Jul 2014 12:21:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, x86-ml <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/17] KEYS: PKCS#7 and PE file signature checking for
 kexec
Message-ID: <20140709162152.GA3894@redhat.com>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
 <20140709160349.GA5292@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709160349.GA5292@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:03:49PM +0200, Borislav Petkov wrote:
> Hi David,
> 
> On Wed, Jul 09, 2014 at 04:15:25PM +0100, David Howells wrote:
> > David Howells (16):
> >       X.509: Add bits needed for PKCS#7
> >       X.509: Export certificate parse and free functions
> >       PKCS#7: Implement a parser [RFC 2315]
> >       PKCS#7: Digest the data in a signed-data message
> >       PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
> >       PKCS#7: Verify internal certificate chain
> >       PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
> >       PKCS#7: Provide a key type for testing PKCS#7
> >       KEYS: X.509: Fix a spelling mistake
> >       Provide PE binary definitions
> >       pefile: Parse a PE binary to find a key and a signature contained therein
> >       pefile: Strip the wrapper off of the cert data block
> >       pefile: Parse the presumed PKCS#7 content of the certificate blob
> >       pefile: Parse the "Microsoft individual code signing" data blob
> >       pefile: Digest the PE binary and compare to the PKCS#7 data
> >       pefile: Validate PKCS#7 trust chain
> > 
> > Vivek Goyal (1):
> >       pefile: Handle pesign using the wrong OID
> 
> let me see if I get this straight:
> 
> this current submission is supposed to replace
> 
> http://lkml.kernel.org/r/20140708131504.28621.61165.stgit@warthog.procyon.org.uk
> 
> and Vivek's one:
> 
> http://lkml.kernel.org/r/1404421641-12691-1-git-send-email-vgoyal@redhat.com
> 
> (which added those parsers to arch/x86/kernel/ - not a good place anyway.)
> 
> ?
> 
> The kexec bits with the sig verif will come ontop, it seems. What's the
> story guys?

[CC akpm and hpa]

Hi Boris,

Yes, this posting will replace above two postings as you said. David
howells anyway did all the original work. So he has refreshed all the
paches, fixed things, put them in right order and reposted.

These are the core patches required to make signature verification work
in bzImage.  We just need one more kexec patch on top which can call into
pefile logic to verify signature of file.

And that patch is sitting right now here.

https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/commit/?h=kexec-pefile&id=7de6fb25559c1dc42e203646c44202cbe2e2fc2c

I am planning to post this single patch for review with explicit mention
to david howells's posting.

So now we have 3 pieces.

- Kexec new system call patches in -mm tree.
- PKCS7 and PEFILE signature verification patches as posted in this
  patch series.
- Final kexec patch which makes use of PEFILE function to do singature
  verification. I will post that patch soon.

I am hoping that last patch can go through david howells tree as it is
dependent on PKCS7 and PEFILE changes.

Thanks
Vivek
