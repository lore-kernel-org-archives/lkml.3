Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3AUSc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:32:29 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56292 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3AUSc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:32:27 -0500
Message-ID: <1358793007.2406.133.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com
Date: Mon, 21 Jan 2013 13:30:07 -0500
In-Reply-To: <20130121164213.GB27617@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <20130121164213.GB27617@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012118-7182-0000-0000-00000497117D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 11:42 -0500, Vivek Goyal wrote:
> On Tue, Jan 15, 2013 at 11:55:59PM -0500, Mimi Zohar wrote:
> 
> [..]
> > Please remind me why you can't use IMA-appraisal, which was upstreamed
> > in Linux 3.7?  Why another method is needed?
> 
> So is this IMA-appraisal also supports digital signatures? The IMA white
> paper seems to put digital signatures in separate category
> (IMA-Appraisal-Signature-Extension).

The white paper was written a couple of years ago, before either EVM or
IMA-appraisal were upstreamed.

- Linux 3.2: Extended Verification Module (EVM) - protects file metadata from offline modification
- Linux 3.3: Dmitry Kasatkin's digital signature verification for use with EVM/IMA-appraisal.
- Linux 3.7: IMA-appraisal/with digital signatures

> > With IMA-appraisal, there are a couple of issues that would still need
> > to be addressed:
> > - missing the ability to specify the validation method required.

Patches to address this issue are available from linux-integrity-test/
#next-ima-appraise-status and were posted on the LSM mailing list as an
RFC (12/18/2012).  Review of these patches would be appreciated.

> > - modify the ima_appraise_tcb policy policy to require elf executables
> > to be digitally signed.
> 
> For my use case, all executable don't have to be digitally signed. If
> something is digitally signed then do the signature verification.

We already discussed this.  Hard coding policy into the Linux kernel is
wrong.

thanks,

Mimi

