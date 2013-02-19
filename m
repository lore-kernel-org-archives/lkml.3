Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3BSKDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab3BSKDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:03:43 -0500
Date: Tue, 19 Feb 2013 07:03:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, rjw@sisk.pl, linux-pm@vger.kernel.org
Subject: Re: SYSFS "errors"
Message-ID: <20130219070310.2cadad7a@redhat.com>
In-Reply-To: <20130218224405.GB21493@pd.tnic>
References: <20130218171334.GA31329@kroah.com>
	<20130218172700.GH2663@arwen.pp.htv.fi>
	<20130218174916.GA2070@kroah.com>
	<20130218184633.GC10755@arwen.pp.htv.fi>
	<20130218164638.7cb53baa@redhat.com>
	<20130218200542.GB20137@arwen.pp.htv.fi>
	<20130218184742.5a4c3c06@redhat.com>
	<20130218215434.GB16794@kroah.com>
	<20130218221306.GA21493@pd.tnic>
	<20130218222618.GA21818@kroah.com>
	<20130218224405.GB21493@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 18 Feb 2013 23:44:05 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Feb 18, 2013 at 02:26:18PM -0800, Greg KH wrote:
> > I don't know, it depends on if userspace can handle this properly or
> > not. What tools rely on this sysfs file? WHat happens when they get a
> > non-number in the file?

The thing with "sdram_scrub_rate" is that this is not supported by any
userspace application I know. I suspect that this is used by userspace
scripts. So, we'll never know in advance what behavior those scripts would
expect.

> 
> I'm not aware of any, frankly speaking.
> 
> If there are any, those tools should be able to handle the -ENODEV
> they get. Now, if this gets changed this way, the read would succeed
> but they'll have to parse the returned value and see that it is not an
> integer.
> 
> So I don't know either.
> 
> But my gut feeling says to stay concervative and not touch this code -
> we don't know what uses it and how much we would break by "fixing" it.
> The current situation is not that big of a deal IMVHO and I'd be willing
> to accept the small inconcistency versus possibly breaking userspace.

I remember I saw some discussions about it in the past at bluesmoke ML,
saying that -ENODEV is the expected behavior when this is not supported.

Changing from -ENODEV to "N/A" will break anything that would be relying
on the previous behavior. So, I think that such change will for sure break
userspace.

If we're willing to change it, not creating the "sdram_scrub_rate" sysfs 
node is less likely to affect userspace.

Regards,
Mauro
