Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaDDPJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaDDPJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:09:53 -0400
Message-ID: <1396624170.2790.9.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
From: Adam Williamson <awilliam@redhat.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 04 Apr 2014 08:09:30 -0700
In-Reply-To: <533EB5F1.8060002@linux.intel.com>
References: <20140404064120.GB11877@gmail.com>
	 <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
	 <20140404080006.GB6944@gmail.com> <533EB5F1.8060002@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 21:38 +0800, Li, Aubrey wrote:
> <cc to adam>
> 
> On 2014/4/4 16:00, Ingo Molnar wrote:
> > 
> >>
> >> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
> > 
> > So, JFYI, I have put this into x86/reboot to get it tested, but it's 
> > not queued up for upstream yet until there's concensus.
> > 
> > (Steve testing it wouldn't hurt either.)
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> The change is originated from the following bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=70931
> 
> The system will hang after BIOS or TRIPLE if it doesn't work, that's why
> I added CF9 before BIOS and TRIPLE.
> 
> Adam may want to try this change to see if reboot works on his DELL
> Venue 8 Pro.
> 
> I don't think there is enough justification to revert the patch. We
> introduce EFI into the default list, we didn't see any reason to remove
> it out so far.

AIUI the bottom line for Baytrail-y devices is that they'll be OK so
long as EFI is tried before anything which causes a hang, right?

I can try patches out for sure and confirm, but it'd be good to have a
definite candidate. Are we considering the first patch alone -
https://patchwork.kernel.org/patch/3937101/ - or also the second patch -
https://patchwork.kernel.org/patch/3937091/ ?
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

