Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968301Ab3HISon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:44:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:23840 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967943Ab3HISom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:44:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,847,1367996400"; 
   d="scan'208";a="383951165"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Topic: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Index: AQHOiHJi+cm++MPa80WiAzcLiv5LH5mKbKhAgAANp+CAAKZzgIAAgIQAgACNcoCAAR/DcA==
Date: Fri, 9 Aug 2013 18:44:41 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A53C03C@ORSMSX106.amr.corp.intel.com>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
 <78b1bca9-80bb-4e60-af3a-738424babfd0@email.android.com>
 <20130808100238.GA27974@pd.tnic> <20130808182853.GD27974@pd.tnic>
In-Reply-To: <20130808182853.GD27974@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79Iimci012043

> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Thursday, August 08, 2013 11:29 AM

> On Thu, Aug 08, 2013 at 12:02:38PM +0200, Borislav Petkov wrote:
> > On Wed, Aug 07, 2013 at 07:22:39PM -0700, H. Peter Anvin wrote:
> > > How much does this matter?
> >
> > I know what you're asking :-)
> >
> > And no, it doesn't really matter as we fail in the patch version
> check
> > so maybe only a comment will suffice here so that people don't get
> > confused.
> 
> IOW, something like that:
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 8 Aug 2013 20:26:24 +0200
> Subject: [PATCH] x86, microcode: Clarify loading on the AP
> 
> Hold it down why we're calling the AP microcode loading routine on the
> BSP too, for future reference.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/cpu/common.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c
> b/arch/x86/kernel/cpu/common.c
> index 25eb2747b063..58d37a27d317 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1226,8 +1226,12 @@ void cpu_init(void)
>  	int i;
> 
>  	/*
> -	 * Load microcode on this cpu if a valid microcode is available.
> -	 * This is early microcode loading procedure.
> +	 * Load microcode on this cpu if a valid microcode is available.
> This
> +	 * is early microcode loading procedure. We execute this on the
> BSP too
> +	 * but since a microcode has been potentially already applied on
> the
> +	 * BSP, we will return prematurely here. It is easier to simply
> call it
> +	 * again than filtering all the possible cases when we're not
> running
> +	 * on the BSP.
>  	 */
>  	load_ucode_ap();

Load_ucode_ap() running on BSP during boot time wastes short time on scanning ucode blob. But the time should be very short. 

Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
