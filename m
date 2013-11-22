Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3KVCab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3KVCa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:30:26 -0500
Date: Thu, 21 Nov 2013 21:29:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jerry.hoemann@hp.com, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131122022957.GE31921@redhat.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <528E94D1.2050809@zytor.com>
 <20131121233705.GA32121@srcf.ucam.org>
 <528EAF99.1010503@zytor.com>
 <20131122012524.GA5627@anatevka.fc.hp.com>
 <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[..]
> > makedumpfile going to cyclic buffer has helped out greatly, but on
> > our new systems we're still looking at 512 MB crash kernels.
> 
> I tried 6TiB system/16 PCIE cards, kdump on RHEL 6.5 beta still does not work.
> still get OOM.

What crashkernel= option you are using?

Interesting. So something is consuming lot of memory. How about setting
"debug_mem_level 1" in /etc/kdump.conf and regenerate initrd and retry.
This time it should output some memory usage info at various points 
during boot and that can give us some idea who is consuming how much
memory.

If some module are consuming lot of memory, then you can try "blacklist"
option in /etc/kdump.conf to disable those.

If it is not modules, then it will concern me because then either
kernel is consuming too much memory (which it should not) or for
some reason makedumpfile cyclic mode did not work for you properly.

While you are re-testing, how about also increasing debug message
level of makedumpfile. makedumpfile developers should be able to 
have a look at that. In /etc/kdump.conf, specify.

core_collector makedumpfile -c --message-level 31 -d 31

If message level 31 turns out to be too verbose, reduce it as per
makedumpfile man page.

Thanks
Vivek
