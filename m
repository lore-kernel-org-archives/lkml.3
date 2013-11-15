Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3KOTNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:13:21 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:20685 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3KOTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:13:12 -0500
Date: Fri, 15 Nov 2013 12:13:08 -0700
From: jerry.hoemann@hp.com
To: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131115191308.GB2748@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
 <20131114180455.GA32212@anatevka.fc.hp.com>
 <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
 <20131115005049.GJ5116@anatevka.fc.hp.com>
 <20131115062417.GB9237@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115062417.GB9237@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 07:24:17AM +0100, Ingo Molnar wrote:
> 
> * jerry.hoemann@hp.com <jerry.hoemann@hp.com> wrote:
> 
> > On Thu, Nov 14, 2013 at 08:44:04PM +0200, Pekka Enberg wrote:
> > > On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
> > > > Making this issue a quirk will be a lot more practical.  Its a small, focused
> > > > change whose implications are limited and more easily understood.
> > > 
> > > There's nothing practical with requiring users to pass a kernel option
> > > to make kdump work.  It's a workaround, sure, but it's not a proper
> > > fix.
> > 
> > One already has to specify command line arguments to enable kdump. 
> > See "crashkernel=" in Documentation/kernel-parameters.txt.
> 
> That option is already a usability barrier. Adding yet another 
> usability barrier improves things how?

  Because of the bug in the way efi_reserve_boot_services is used:

  On pre 3.9 kernel crash dump doesn't work at all w/ fragmented memory < 896M.

  On post 3.9 it doesn't work by default and even when changing
  invocation, has some issue (see vivek's email.)

  i am looking for a solution for all these cases.

> 
> > As i said in an earlier mail we are working w/ distros. [...]
> 
> The point being?

  Earlier reviewer asserted:

	"There's nothing practical with requiring users to pass a kernel option"

  I pointed out that these type of arguments can and do get added by distros
  and that users need not be actively involved.  the tools abstract
  these details out.

  we are working w/ distros to get kdump working on large servers which
  it currently does not do.  as such, this change would be seamless to
  users.

  but as i've said in earlier replies, i'm willing to do a white list.
  its not as flexible, but its much better than the current situation
  that we face (especially on pre 3.9 kernels.)


> 
> > [...]  distros can and do specify lots of interesting command line 
> > arguments for their systems.  Distros have tools for configuring 
> > kdump. User must already use these tools or manually edit multiple 
> > config files, to get kdump to work.  I would work with distros to 
> > help integrate this change into their tools.
> 
> Here you describe a method that has already successfully cut the kdump 
> user base to a fraction of its potential size. Why should we assist to 
> that effort of engineered obscurity?
> 
> > As i said in earlier mail, i am willing to change implementation to 
> > some type of black/white listing.
> 
> Is it possible to fix it the way hpa suggested?

  I think the changes to enable ,high is a step in the
  right direction. its an improvement  But it is still green.

  We are having lots more problems w/ upstream kdump than we are having
  w/ the kdump in distros.

  So, to answer your question with a slight twist:

  Is it possible to back ports lots of green code across multiple
  versions and distros and get a bug free user experiences?  I guess so.

  is it the right way to go?  i personally don't think so.

  but hey, others may have a different view.


  Jerry


> 
> Thanks,
> 
> 	Ingo

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

