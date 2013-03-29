Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3C2SFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:05:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:4784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab3C2SFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:05:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,374,1363158000"; 
   d="scan'208";a="313765873"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jiri Slaby <jslaby@suse.cz>, Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Borislav Petkov <bp@alien8.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: e1000e + suspend, 3.9-rc2
Thread-Topic: e1000e + suspend, 3.9-rc2
Thread-Index: AQHOHo1yPcCqC9Kgs0+/ioixgRgrdpihW2oAgAAKAoCAAV3XgIAKisEAgAADDgCAACAiAIAPn7WQ
Date: Fri, 29 Mar 2013 18:04:42 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1844D9F3062@ORSMSX103.amr.corp.intel.com>
References: <20130311191936.GD5000@pd.tnic> <513E355C.4000204@gmail.com>
 <20130311202537.GF5000@pd.tnic> <20130312171745.GE5370@pd.tnic>
 <51483B1A.9090704@suse.cz> <51483DAA.7060806@openvz.org>
 <5148589E.8030509@suse.cz>
In-Reply-To: <5148589E.8030509@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2TI5KOJ030036

> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
> Sent: Tuesday, March 19, 2013 5:23 AM
> To: Konstantin Khlebnikov
> Cc: Borislav Petkov; Kirsher, Jeffrey T; Rafael J. Wysocki; Bjorn Helgaas;
> x86@kernel.org; lkml; e1000-devel@lists.sourceforge.net; Allan, Bruce W
> Subject: Re: e1000e + suspend, 3.9-rc2
> 
> >>> Ok, I can still see the hardware error message when suspending:
> >>
> >> And with 3.8 plus these:
> >>      PCI/PM: Clear state_saved during suspend
> >>      e1000e: fix pci-device enable-counter balance
> >>      e1000e: fix runtime power management transitions
> >>      e1000e: fix accessing to suspended device
> >>
> >> I sometimes see this:
> >> pci_pm_suspend():e1000_suspend +0x0/0x10 [e1000e] returns -2
> >> dpm_run_callback(): pci_pm_suspend+0x0/0x140 returns -2
> >> PM: Device 0000:00:19.0 failed to suspend async: error -2
> >>
> >> Any ideas? Am I missing some patch still?
> >
> > Try this:
> > "PCI: Don't try to disable Bus Master on disconnected PCI devices"
> > https://patchwork.kernel.org/patch/2271641/
> >
> > But I'm not sure, probably it is unrelated because this code works only (?)
> > during shutdown/kexec sequences.
> 
> I don't think it will help either. -2 here is -E1000_ERR_PHY from
> e1000e_write_phy_reg_mdic if I'm looking correctly. I.e. MDIC not ready
> or unlike MDIC_ERROR.
> 
> I think this happened after I put the link down and tried to suspend.
> 
> --
> js
> suse labs

Sorry for not replying sooner, for some reason some of this thread was filtered
to my junk folder and I didnâ€™t see it until now.

Jiri, can you provide the output of 'lspci -s 00:19.0 -n -vv' and confirm the scenario
in which the problem occurs?  Is this easily reproduced?

Thanks,
Bruce.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
