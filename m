Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHRRkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:40:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53568 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702AbaHRRkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:40:35 -0400
Date: Mon, 18 Aug 2014 18:40:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to
	unistd.h
Message-ID: <20140818174010.GZ30401@n2100.arm.linux.org.uk>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com> <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com> <20140811171511.GF8828@arm.com> <201408112057.01177.arnd@arndb.de> <CAMuHMdWZ30ZKO2ddh8whmw5ThrKZC0wsU+rhgoc8fRZni0Zduw@mail.gmail.com> <20140812102734.GG29013@arm.com> <20140812111030.GK29013@arm.com> <20140812123736.GA16961@redhat.com> <20140815135520.GT27466@arm.com> <20140818171540.GE4745@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818171540.GE4745@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 01:15:40PM -0400, Vivek Goyal wrote:
> On Fri, Aug 15, 2014 at 02:55:20PM +0100, Will Deacon wrote:
> > What I meant was, if I wire it into asm-generic/unistd.h then it will return
> > -ENOEXEC for architectures using that file (e.g. arm64).
> > 
> > Patch below, but I don't think it's very useful.
> > 
> 
> Hi Will,
> 
> I have not even defined a syscall number for other arches. IIUC, this
> patch will forcibly introduce a syscall number for the new syscall for
> arches which use asm-generic/unistd.h.
> 
> So question I have is that why should we do it now. One can do it once
> somebody enables kexec_file_load() on arm64.
> 
> Right now I see that kexec_file_load() gets compiled if CONFIG_KEXEC=y. So
> even on arm64 it must be getting compiled in. But it is not being hooked
> up using system call table. So there should not be any way to invoke
> syscalll definition. So my understand is that in current form, one can
> not invoke kexec_file_load() on arm64. Is that right.
> 
> Now I have put one more patch to make compilation of kexec_file_load()
> conditional on config option CONFIG_KEXEC_FILE. And this option can
> be enabled only on x86_64. That means kexec_file_load() will not even
> be compiled in on arm64 (once the patch gets merged). Right now patch
> is sitting in andrew's tree.
> 
> http://ozlabs.org/~akpm/mmotm/broken-out/kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch
> 
> Can you please help me understand that why do we need this patch if at
> this point of time we are not even fixing a system call number for
> kexec_file_load() for arches except x86_64.

>From what I read, the only arch which supports this call is x86_64, and
it requires arch code make work.  So simply wiring up the syscall is not
enough.

What is probably worth doing is reserving the syscall number _if_ it's
going to be useful on architectures - by that, I mean inserting the
syscall number with a comment in the unistd.h file, rather than
defining a constant.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
