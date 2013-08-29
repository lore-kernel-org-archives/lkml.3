Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3H2Rbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:31:39 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59990 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3H2Rbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:31:37 -0400
Date: Thu, 29 Aug 2013 10:31:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130829173133.GA549@roeck-us.net>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
 <20130801134632.GY9916@kw.sim.vm.gnt>
 <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
 <20130829125754.GA8813@srcf.ucam.org>
 <521F4F95.5080103@roeck-us.net>
 <20130829153738.GA16306@srcf.ucam.org>
 <20130829160830.GB25021@roeck-us.net>
 <20130829162551.GA17411@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829162551.GA17411@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 05:25:51PM +0100, Matthew Garrett wrote:
> On Thu, Aug 29, 2013 at 09:08:30AM -0700, Guenter Roeck wrote:
> > On Thu, Aug 29, 2013 at 04:37:38PM +0100, Matthew Garrett wrote:
> > > On Thu, Aug 29, 2013 at 06:41:41AM -0700, Guenter Roeck wrote:
> > > The majority of board vendors clearly don't expect the OS to drive the 
> > > hwmon chips - they're there for the benefit of ACPI and SMM code. That 
> > > doesn't mean that there's no benefit in having drivers for them, just 
> > > that the board vendors don't care about that use case and so won't do 
> > > anything to make it easier.
> > > 
> > Actually, not entirely true. Some vendors even provide software running on
> > Windows to access those chips (including access to fans controlled through
> > GPIO pins) and to provide information to the user. It might be more accurate
> > to say that some board vendors don't care about Linux (or about providing
> > access through ACPI, for that matter).
> 
> Eh. If they're really providing code that just assumes that hardware is 
> present and bangs on it, what choice do we have? You've checked that the 
> machines in question don't have a magic ACPI device that provides 
> resource information?
> 
Not to my knowledge. One vendor doing this extensively is ASRock. They have
a Windows based tuning aplication which lets users even set chip voltages
through SuperIO GPIO pins. Not that I would recommend supporting anything
like that in Linux ;).

I also have a couple of Intel motherboards which don't support ACPI methods 
to access hardware monitoring information or the watchdog on the SuperIO chip.
Guess they don't want me to use that information ;).

There is lots of hardware monitoring tools available for Windows. Practically
none of them uses ACPI to collect the information from the hardware. Instead,
they use the same method we use in the Linux kernel to detect the SuperIO chip.
An open source tool is http://openhardwaremonitor.org/. 

> > Question here is what the Linux kernel community's policy is going to be
> > to handle such cases. Pragmatic or dogmatic ?
> 
> I don't see any benefit in changing the status quo. Sometimes hardware 
> is just shit. The majority of x86 vendors certainly don't care about 
> anything we do, so it's not like we're in a position to force them to 
> change.
> 
Me not either. It just sounded to me that this was the suggestion, so I was
asking for clarification. It doesn't make sense for people like me to submit
a driver into the kernel only to have it rejected for non-technical reasons.

Guenter
