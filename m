Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab3EWOsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589Ab3EWOsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:48:13 -0400
Date: Thu, 23 May 2013 10:48:00 -0400
From: Dave Jones <davej@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: microcode loading got really slow.
Message-ID: <20130523144800.GB16419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Takashi Iwai <tiwai@suse.de>, Ming Lei <tom.leiming@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	fenghua.yu@intel.com
References: <s5h7giq86hr.wl%tiwai@suse.de>
 <s5hwqqqvw59.wl%tiwai@suse.de>
 <CACVXFVMsTjSqvyVkZEPfWgHDUJ_mqwqWy=vydCsTvv7TS-EKiQ@mail.gmail.com>
 <s5hr4gyvv7r.wl%tiwai@suse.de>
 <CACVXFVNO9FeCaJ_YFbvPMUHOBjneLqqW+ucYprZb7884Eth-DA@mail.gmail.com>
 <s5hmwrlx5np.wl%tiwai@suse.de>
 <CACVXFVMm=dKz9mwt=moU4Dw9-K=offHb10S3sV2-cxiQ5vH_cA@mail.gmail.com>
 <s5h38tdx24r.wl%tiwai@suse.de>
 <CACVXFVOy95SzeL2_wHMShZwG7eE7evrZhaEvJAsd1LLDcSD1Vw@mail.gmail.com>
 <s5hhahtvk4b.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhahtvk4b.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 04:36:20PM +0200, Takashi Iwai wrote:
 
 > > >> Also udev supports user-defined rules to load firmware, which
 > > >> means some drivers may not put their firmware in the default
 > > >> path of distribution's firmware.
 > > >
 > > > It's why I suggested to put a warning in that path as the first step.
 > > > So we can see whether there is any actual user.
 > > 
 > > If you plan to do it, it'd better to add default firmware path of some
 > > distributions into firmware_class.c first, otherwise it may cause
 > > unnecessary noise for this distribution.
 > >
 > > But if more default search paths are added, it might cause mistaken
 > > firmwares found under incorrect path, for example, android's
 > > default path is "/etc/firmware" and "/vendor/firmware"(maybe different
 > > for different versions).
 > > 
 > > Also, putting default search paths into kernel isn't good, which was
 > > introduced unwillingly for well-known reason.
 > 
 > Maybe we can create a new Kconfig to specify non-standard firmware
 > path?

You keep mentioning non-standard paths for firmware, but in this case,
I don't think Fedora is doing anything unusual.  We have microcode firmware
in /lib/firmware/intel-ucode/ just like (afaik) everyone else.

What *is* happening, I think is that the CPU is new enough that there's no
newer firmware file available for it. 

thoughts?

	Dave

