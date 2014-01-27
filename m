Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaA0G4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:56:47 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:44846 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaA0G4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:56:45 -0500
Date: Sun, 26 Jan 2014 22:56:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Raghu Gandham <Raghu.Gandham@imgtec.com>
Cc: "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: i8042-io - Exclude mips platforms when
 allocating/deallocating IO regions.
Message-ID: <20140127065638.GB11945@core.coreip.homeip.net>
References: <1390676514-30880-1-git-send-email-raghu.gandham@imgtec.com>
 <20140126214952.GD18840@core.coreip.homeip.net>
 <E2EE47005FA75F44B80E1019FDD2EBBB6E38B06D@BADAG02.ba.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2EE47005FA75F44B80E1019FDD2EBBB6E38B06D@BADAG02.ba.imgtec.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 12:32:36AM +0000, Raghu Gandham wrote:
> Hi Dmitry, 
> 
> > 
> > On Sat, Jan 25, 2014 at 11:01:54AM -0800, Raghu Gandham wrote:
> > > The standard IO regions are already reserved by the platform code on
> > > most MIPS devices(malta, cobalt, sni). The Commit
> > > 197a1e96c8be5b6005145af3a4c0e45e2d651444
> > > ("Input: i8042-io - fix up region handling on MIPS") introduced a bug
> > > on these MIPS platforms causing i8042 driver to fail when trying to reserve
> > IO ports.
> > > Prior to the above mentioned commit request_region is skipped on MIPS
> > > but release_region is called.
> > >
> > > This patch reverts commit 197a1e96c8be5b6005145af3a4c0e45e2d651444
> > and
> > > also avoids calling release_region for MIPS.
> > 
> > The problem is that IO regions are reserved on _most_, but not _all_ devices.
> > MIPS should figure out what they want to do with i8042 registers and be
> > consistent on all devices.
> 
> Please examine the attached patch which went upstream in April of 2004.  Since then
> it had been a convention not to call request_region routine in i8042 for MIPS. The
> attached patch had a glitch that it guarded request_region in i8042-io.h but skipped 
> guarding release_region in i8042-io.h. I believe that the issue Aaro saw was due to this 
> glitch. Below is the error quoted in Aaro's commit message.
> 
>     [    2.112000] Trying to free nonexistent resource <0000000000000060-000000000000006f>
> 
> My patch reinstates the convention followed on MIPS devices along with fixing Aaro's issue.

I assume that Aaro did test his patch and on his box request_region()
succeeds. That would indicate that various MIPS sub-arches still not
settled on the topic.

Aaro?

Thanks.

-- 
Dmitry
