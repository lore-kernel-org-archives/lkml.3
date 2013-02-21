Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3BUTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:04:27 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51589 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3BUTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:04:25 -0500
Message-ID: <1361473420.29360.97.camel@falcor1>
Subject: Re: [GIT] Security subsystem updates for 3.9
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Thu, 21 Feb 2013 14:03:40 -0500
In-Reply-To: <CA+55aFxSgVX=d5RvL0kSTm5KQR-AJ=+t_+jXv9J+J3f-C4MOfA@mail.gmail.com>
References: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
	 <CA+55aFzkBA6bdLe73PKBaQNfV1m-JqSddF24-F-s1rX3oRE2Lg@mail.gmail.com>
	 <1361469979.29360.75.camel@falcor1>
	 <CA+55aFxSgVX=d5RvL0kSTm5KQR-AJ=+t_+jXv9J+J3f-C4MOfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022119-5806-0000-0000-00002000AFA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 10:21 -0800, Linus Torvalds wrote:
> On Thu, Feb 21, 2013 at 10:06 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > Almost, and enforcing file integrity is enabled.  The merged result
> > should look like what's contained in
> > linux-integrity/next-upstreamed-patches:
> >
> > int ima_module_check(struct file *file)
> > {
> >         if (!file) {
> >                 if ((ima_appraise & IMA_APPRAISE_MODULES) &&
> >                     (ima_appraise & IMA_APPRAISE_ENFORCE)) {
> > #ifndef CONFIG_MODULE_SIG_FORCE
> >                         return -EACCES; /* INTEGRITY_UNKNOWN */
> > #endif
> >                 }
> >                 return 0;
> 
> Ugh. The placement of that #ifndef is just horrible, please don't do
> that. Just add it around the whole if-statement rather than around
> just the return. Not because the compiler can't optimize away the
> tests, but because it's much more obvious to a *human* what the ifndef
> actually does.

Having the 'ifndef' is ugly.  Thanks for the suggestion on making it
less ugly.

> Anyway, I don't have the IMA_APPRAISE_ENFORCE bit checking, it wasn't
> obvious from the conflict, so somebody will need to add that.

Commit "750943a ima: remove enforce checking duplication" moved the test
to process_measurement().

Because commit "a7f2a36 ima: fallback to MODULE_SIG_ENFORCE for existing
kernel module syscall" never went into linux-security/next, subsequent
patches resulted in this merge conflict.

I'll post an additional patch.

thanks,

Mimi



