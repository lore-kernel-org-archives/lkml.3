Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3CLRRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:17:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51538 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3CLRRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:17:49 -0400
Date: Tue, 12 Mar 2013 18:17:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: jeffrey.t.kirsher@intel.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: e1000e + suspend, 3.9-rc2
Message-ID: <20130312171745.GE5370@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	jeffrey.t.kirsher@intel.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Bruce Allan <bruce.w.allan@intel.com>
References: <20130311191936.GD5000@pd.tnic>
 <513E355C.4000204@gmail.com>
 <20130311202537.GF5000@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130311202537.GF5000@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:25:37PM +0100, Borislav Petkov wrote:
> Yeah, it is already upstream. And yeah, it did trigger with it.
> 
> $ git describe
> v3.9-rc2-112-g7c6baa304b84
> 
> But it somehow doesn't trigger with that same kernel anymore so I'll
> consider it a glitch and watch it over the next days.

Ok, I can still see the hardware error message when suspending:

...
Mar 12 18:11:15 nazgul vmunix: [ 3001.399727] PM: Syncing filesystems ... done.
Mar 12 18:11:42 nazgul vmunix: [ 3001.407296] Freezing user space processes ... (elapsed 0.01 seconds) done.
Mar 12 18:11:42 nazgul vmunix: [ 3001.420156] PM: Preallocating image memory... done (allocated 109074 pages)
Mar 12 18:11:42 nazgul vmunix: [ 3001.575708] PM: Allocated 436296 kbytes in 0.15 seconds (2908.64 MB/s)
Mar 12 18:11:42 nazgul vmunix: [ 3001.576290] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Mar 12 18:11:42 nazgul vmunix: [ 3001.588245] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
Mar 12 18:11:42 nazgul vmunix: [ 3001.690813] ehci-pci 0000:00:1a.0: setting latency timer to 64
Mar 12 18:11:42 nazgul vmunix: [ 3001.703795] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
Mar 12 18:11:42 nazgul vmunix: [ 3001.805842] ehci-pci 0000:00:1d.0: setting latency timer to 64
Mar 12 18:11:42 nazgul vmunix: [ 3001.808563] Suspending console(s) (use no_console_suspend to debug)
Mar 12 18:11:42 nazgul vmunix: [ 3001.811022] xhci_hcd 0000:00:14.0: WARN Event TRB for slot 1 ep 0 with no TDs queued?
Mar 12 18:11:42 nazgul vmunix: [ 3002.372862] e1000e 0000:00:19.0 eth0: Hardware Error
									^^^^^

But that's the only line there, nothing more from e1000e.. After that
the box suspends ok and I can resume back normally... AFAICT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
