Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3KOAvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:51:00 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45138 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3KOAux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:50:53 -0500
Date: Thu, 14 Nov 2013 17:50:49 -0700
From: jerry.hoemann@hp.com
To: Pekka Enberg <penberg@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131115005049.GJ5116@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
 <20131114180455.GA32212@anatevka.fc.hp.com>
 <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 08:44:04PM +0200, Pekka Enberg wrote:
> On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
> > Making this issue a quirk will be a lot more practical.  Its a small, focused
> > change whose implications are limited and more easily understood.
> 
> There's nothing practical with requiring users to pass a kernel option
> to make kdump work.  It's a workaround, sure, but it's not a proper
> fix.


One already has to specify command line arguments to enable kdump.
See "crashkernel=" in Documentation/kernel-parameters.txt.

As i said in an earlier mail we are working w/ distros.  distros
can and do specify lots of interesting command line arguments for
their systems.  Distros have tools for configuring kdump.
User must already use these tools or manually edit multiple config files,
to get kdump to work.  I would work with distros to help integrate this
change into their tools.


As i said in earlier mail, i am willing to change implementation
to some type of black/white listing.

> 
> And once you add whitelisting to make it practical, implications are
> no longer limited nor easily understood nor actually testable unless
> you happen to have access every single firmware out there.

Perhaps we have a different understanding of black/white listings.

Here is what i mean:

the use of efi_reserve_boot_services is a work around for system
with fw bugs.

Black list:
1. In general, assume systems don't need the work around.
2. The black list are those specific system on which the work around
   is applied.

White list:
1. In general, assume systems require the work around.
2. The white list are those specific system in which the work around
   is not applied.


In the white list case, the list of platforms would be the ones
that i specifically test and verify don't need the work around.
the only difference is whether BootService Code/Data is reserved/freed
early.

all other platforms remain the same.


> 
> Yes, we have plenty of quirks in the x86 boot code but that doesn't
> mean it's a good idea to add more of the unless we absolutely must.

given that life is optional, how can one argue any piece of software be
an absolute must?  :)  :)

Jerry

> 
>                                 Pekka

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

