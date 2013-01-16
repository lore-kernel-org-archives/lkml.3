Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3APTY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:24:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38351 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3APTY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:24:56 -0500
Message-ID: <1358364290.4593.178.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Date: Wed, 16 Jan 2013 14:24:50 -0500
In-Reply-To: <20130116182804.GF29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	 <20130116144836.GB29845@redhat.com> <1358350391.4593.112.camel@falcor1>
	 <20130116163453.GD29845@redhat.com> <1358359715.4593.146.camel@falcor1>
	 <20130116182804.GF29845@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011619-7182-0000-0000-0000047D1DB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 13:28 -0500, Vivek Goyal wrote:
> On Wed, Jan 16, 2013 at 01:08:35PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-01-16 at 11:34 -0500, Vivek Goyal wrote:
> > 
> > > I read the comment in ima_bprm_check() being called from security_bprm_check(). 
> > > It says that files already open for write can't executed and files already
> > > open for exec can't be open for writes. That's fine. 
> > > 
> > > I was worried about anonymous pages being modified on swap and then
> > > faulted back in. It is not necessarily signature verification but making
> > > sure signed processes memory is not modified later by any unsigned process
> > > in anyway. And that includes disabling ptrace too.
> > > 
> > > So IMA stuff does not do anything to protect against process memory being
> > > modified using ptrace or by playing tricks with swap.
> > 
> > > I am not sure what will happen if I can bypass the file system and directly
> > > write on a disk block and modify executable. (Assuming one can get block
> > > information somehow). Does anything protect such modification? Will IMA
> > > detect it?
> > 
> > Sorry, this is out of scope for IMA.  Dmitry has looked into this, but
> > I'm not sure where it stands at the moment.
> 
> Ok, so that's one reason that why I wrote these patcehs. IMA currently
> is not doing following things to make sure address space of signed images
> is not modified by others.
> 
> - Protecting against modifications to pages on swap.
> - Protecting against modifications by ptrace.
> - Protecting against modifications which bypassed filesystem and directly
>   wrote to the block.
> 
> Locking down all the pages of signed binaries in memory hopefully should
> solve above problems.

Signing and verifying ELF executables goes back a long time ~2003/4,
from a number of esteemed kernel developers, including Greg-KH and Serge
Hallyn.

IMA-appraisal isn't limited to appraising a single type of file, but is
a generic mechanism for appraising all files.  If there are issues that
aren't being addressed, then by all means, please help by addressing
them.  Duplicating a large portion of the code is not productive.

thanks,

Mimi


