Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLFFBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:01:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaLFFBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:01:51 -0500
Date: Sat, 6 Dec 2014 13:01:40 +0800
From: Baoquan He <bhe@redhat.com>
To: MegaBrutal <megabrutal@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: PROBLEM: [Launchpad #1396889] [Lenovo ThinkPad T400] kexec
 reboot fails
Message-ID: <20141206050140.GA2458@dhcp-17-102.nay.redhat.com>
References: <CAE8gLhn9wFBLvdxTonD5m8Q_wYG_eg_TQOuZnEFPEVXstHdbvw@mail.gmail.com>
 <CAE8gLhkBUWrXsRxBDTpj1sNVKZLe7aVeqMuJArW2ACOkvpR-OQ@mail.gmail.com>
 <CAGXu5jJYw+x=YU5O1k=isuxx6gKRP4zQYj03tZYx6mLW0qLPfw@mail.gmail.com>
 <CAE8gLhmxEoJ-7vs+avCite=zWZkVF9t8Y1c8yTu887aFYULRiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE8gLhmxEoJ-7vs+avCite=zWZkVF9t8Y1c8yTu887aFYULRiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/14 at 04:10am, MegaBrutal wrote:
> 2014-12-01 23:59 GMT+01:00 Kees Cook <keescook@chromium.org>:
> >
> > I suspect you're encountering a subset of the same problems as
> > described in this thread:
> > https://lkml.org/lkml/2014/9/30/90
> >
> > If you can test those patches, that may help demonstrate their utility.
> >
> > Thanks!
> 
> Bang ji le! It works with the patch you linked, xiexie!
> I suggest it to be merged into mainline.
> 
> Anyway, is there a way to get sure that KASLR actually works now?
> (I.e. how do I know if the kernel is really loaded to a random
> address?)

I usually check the elf header of /proc/kcore which represents the
physical memory of the system and is stored in the ELF core file format.
Without kaslr, the kernel text mapping should be in virtual addr
0xffffffff81000000. With kaslr enabled, the addr would be anywhere
between 0xffffffff80000000 and 0xffffffffc0000000.

> Do you have any idea what might be different with my ThinkPad T400
> that it is the only one of my machines affected?

That's weird. I suggest you check the config file for that running
kernel in your ThinkPad T400. If you have below config, that means your
kernel support kaslr and enable it by default, unless you specify
nokaslr in cmdline to disalbe it.
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000 

Different kind of machines should not affect this.

Thanks
Baoquan
