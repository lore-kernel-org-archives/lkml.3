Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3KRPmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:42:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3KRPmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:42:31 -0500
Date: Mon, 18 Nov 2013 10:42:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: jerry.hoemann@hp.com
Cc: Ingo Molnar <mingo@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131118154209.GC32168@redhat.com>
References: <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
 <20131114180455.GA32212@anatevka.fc.hp.com>
 <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
 <20131115005049.GJ5116@anatevka.fc.hp.com>
 <20131115062417.GB9237@gmail.com>
 <20131115191308.GB2748@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115191308.GB2748@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:13:08PM -0700, jerry.hoemann@hp.com wrote:

[..]
> > Is it possible to fix it the way hpa suggested?
> 
>   I think the changes to enable ,high is a step in the
>   right direction. its an improvement  But it is still green.
> 
>   We are having lots more problems w/ upstream kdump than we are having
>   w/ the kdump in distros.
> 
>   So, to answer your question with a slight twist:
> 
>   Is it possible to back ports lots of green code across multiple
>   versions and distros and get a bug free user experiences?  I guess so.
> 
>   is it the right way to go?  i personally don't think so.
> 
>   but hey, others may have a different view.

I agree that backporting a fix/hack to not reserve EFI boot memory on
certain platform is much easier as compared to backporting capability to
boot from higher memory addresses.

I also agree that crashkernel=X,high support is very new and it has yet to
go though a wide spread testing to confirm that it works well with wide
variety of machines. And this also makes a case to stick to crashkernel=X
for older releases and just backport a fix to not reserve EFI boot time
memory.

Thanks
Vivek
