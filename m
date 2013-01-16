Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3APS2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab3APS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:28:20 -0500
Date: Wed, 16 Jan 2013 13:28:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130116182804.GF29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <871udloiku.fsf@xmission.com>
 <1358312159.4593.37.camel@falcor1>
 <87wqvdli1o.fsf@xmission.com>
 <1358344859.4593.66.camel@falcor1>
 <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
 <20130116163453.GD29845@redhat.com>
 <1358359715.4593.146.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358359715.4593.146.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 01:08:35PM -0500, Mimi Zohar wrote:
> On Wed, 2013-01-16 at 11:34 -0500, Vivek Goyal wrote:
> 
> > I read the comment in ima_bprm_check() being called from security_bprm_check(). 
> > It says that files already open for write can't executed and files already
> > open for exec can't be open for writes. That's fine. 
> > 
> > I was worried about anonymous pages being modified on swap and then
> > faulted back in. It is not necessarily signature verification but making
> > sure signed processes memory is not modified later by any unsigned process
> > in anyway. And that includes disabling ptrace too.
> > 
> > So IMA stuff does not do anything to protect against process memory being
> > modified using ptrace or by playing tricks with swap.
> 
> > I am not sure what will happen if I can bypass the file system and directly
> > write on a disk block and modify executable. (Assuming one can get block
> > information somehow). Does anything protect such modification? Will IMA
> > detect it?
> 
> Sorry, this is out of scope for IMA.  Dmitry has looked into this, but
> I'm not sure where it stands at the moment.

Ok, so that's one reason that why I wrote these patcehs. IMA currently
is not doing following things to make sure address space of signed images
is not modified by others.

- Protecting against modifications to pages on swap.
- Protecting against modifications by ptrace.
- Protecting against modifications which bypassed filesystem and directly
  wrote to the block.
 
Locking down all the pages of signed binaries in memory hopefully should
solve above problems.

Thanks
Vivek
