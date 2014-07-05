Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbaGEDCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 23:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395AbaGEDCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 23:02:00 -0400
Date: Fri, 4 Jul 2014 23:01:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        dhowells@redhat.com, pjones@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/9] kexec: Verify signature of PE signed bzImage
Message-ID: <20140705030134.GA18508@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
 <20140704145118.GD3340@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704145118.GD3340@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 04:51:18PM +0200, Borislav Petkov wrote:
> On Thu, Jul 03, 2014 at 05:07:12PM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > This patch series enables signature verification of signed PE bzimage. This
> > patches series needs two more patch series before it.
> > 
> > First one is kexec_file_load() syscall support posted here.
> > 
> > https://lkml.org/lkml/2014/6/26/497
> > 
> > This patch seris is also available in -mm tree now.
> > 
> > Second one is PKCS7 signature parsing and verification support. These
> > patches are available in David Howells's modsign tree in pkcs7 branch.
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pkcs7
> > 
> > This patch series is based on David Howells's work of PE file parsing
> > and PKCS7 signature verificaiton. Now PKCS7 signature part is available
> > in his tree. So I have taken PE file parsing patches, changed them a
> > bit and posting these here.
> 
> Ok, now this looks strange. You're referring to those patches without
> posting them together with yours. And they're in some repo. Normally in
> such cases people post the *whole* patchset and do not refer to some
> other tree.

> 
> >From looking at them, they're part of the pull request which Linus did
> shot down already last year:
> 
> https://lkml.org/lkml/2013/2/21/228
> 
> And he explicitly stated then that we don't want PE file parsing in the
> kernel, AFAICR. What changed since then?

I think use case has changed since then. My impression was that Linus
primarily did not like the idea of carrying keys in PE files. He said
we have x509 for that.

This time that's not the use case. We have dropped those patches. In fact
no keys are being added. I am just verifying the signature of PE bzImage
against a key in system_trusted_keyring.

We already generate PE bzImage and have code to generate right PE header
for bzImage.

In Linux Plumbers last year idea was to append signatures to kernel image
(like modules). But later I found out that it will not work as if I append
another signature to already signed PE image, PE signatures will be broken.

And given that distributions are already shipping signe PE bzImage, it
made sense to parse and verify those signatures instead of trying to
come up with a mechanism so that two signatures can co-exist and sign
images twice.

Given that this time we have a new use case, I am hoping that idea of
parsing PE and verifying signature is more acceptable.

Thanks
Vivek
