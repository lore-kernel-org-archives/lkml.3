Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3EaTcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:32:16 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:59570 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3EaTcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:32:07 -0400
Date: Fri, 31 May 2013 21:32:00 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130531193200.GA8346@alberich>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <20130531042649.GA4488@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130531042649.GA4488@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 01:26:49AM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 30 May 2013, Jacob Shin wrote:
> >  mkdir initrd
> >  cd initrd
> > -mkdir kernel
> > -mkdir kernel/x86
> > -mkdir kernel/x86/microcode
> > -cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
> > -find .|cpio -oc >../ucode.cpio
> > +mkdir -p kernel/x86/microcode
> > +cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin (or AuthenticAMD.bin)
> 
> Can I just 
> 'cat /lib/firmware/amd-ucode/*bin >kernel/x86/microcode/AuthenticAMD.bin' 
> to get a valid microcode container for all amd processors?
> 
> The answer for Intel is "yes".  I sure hope it is the same for AMD...

No, this doesn't work for AMD.

The container file includes a header section with information how to
map CPU F/M/S to microcode revisions provided with a container
file. Concatenating several container files will not create an
all-embracing header section.

More details were available on the amd64.org web pages.  But it seems
that the web site is not available anymore ...


Andreas
