Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab3EWPzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab3EWPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:55:44 -0400
Date: Thu, 23 May 2013 11:55:32 -0400
From: Dave Jones <davej@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: microcode loading got really slow.
Message-ID: <20130523155532.GE16419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>, Takashi Iwai <tiwai@suse.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	fenghua.yu@intel.com
References: <s5hr4gyvv7r.wl%tiwai@suse.de>
 <CACVXFVNO9FeCaJ_YFbvPMUHOBjneLqqW+ucYprZb7884Eth-DA@mail.gmail.com>
 <s5hmwrlx5np.wl%tiwai@suse.de>
 <CACVXFVMm=dKz9mwt=moU4Dw9-K=offHb10S3sV2-cxiQ5vH_cA@mail.gmail.com>
 <s5h38tdx24r.wl%tiwai@suse.de>
 <CACVXFVOy95SzeL2_wHMShZwG7eE7evrZhaEvJAsd1LLDcSD1Vw@mail.gmail.com>
 <s5hhahtvk4b.wl%tiwai@suse.de>
 <20130523144800.GB16419@redhat.com>
 <s5hbo81viq4.wl%tiwai@suse.de>
 <CACVXFVP=9AJKGDM8hcrCv7+dQBtsqi39AFwFO2bsUxcrsGg2wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVP=9AJKGDM8hcrCv7+dQBtsqi39AFwFO2bsUxcrsGg2wQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:27:08PM +0800, Ming Lei wrote:
 > > Yes, in your case, everything is fine in the kernel itself.  And no
 > > microcode update is needed for new CPU, thus no firmware.
 > 
 > Can the driver decide if the CPU need microcode? Or there will
 > be the microcode for the CPU in future?

The kernel can't know. The microcode updates are asynchonously released
from the kernel. I might be running a months old kernel, and get a new
microcode tomorrow.  The kernel handles this by looking for a file
with a name matching the cpu family/model/stepping. (See how they are
formed in /lib/firmware/intel-ucode/*)

	DAve

