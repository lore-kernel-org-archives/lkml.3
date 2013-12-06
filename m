Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3LFQIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:08:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:17906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab3LFQIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:08:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,841,1378882800"; 
   d="scan'208";a="420521225"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Xudong Hao <xudong.hao@intel.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>
Subject: RE: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
Thread-Topic: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
Thread-Index: AQHO8nebMlvXPHXMtk+dmceDygSpLppGqBiAgACsPhA=
Date: Fri, 6 Dec 2013 16:08:45 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014A4374@SHSMSX102.ccr.corp.intel.com>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <1386355976-11732-3-git-send-email-qiaowei.ren@intel.com>
 <20131206134631.GD6694@pd.tnic>
In-Reply-To: <20131206134631.GD6694@pd.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB6G8xI3020265


> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Friday, December 06, 2013 9:47 PM
> To: Ren, Qiaowei
> Cc: Paolo Bonzini; H. Peter Anvin; Ingo Molnar; Thomas Gleixner;
> x86@kernel.org; linux-kernel@vger.kernel.org; qemu-devel@nongnu.org;
> kvm@vger.kernel.org; Xudong Hao; Liu, Jinsong
> Subject: Re: [PATCH 3/3] X86, mpx: Intel MPX xstate feature definition
> 
> On Sat, Dec 07, 2013 at 02:52:56AM +0800, Qiaowei Ren wrote:
> 
> Commit message please.
> 
> > Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> > ---
> >  arch/x86/include/asm/processor.h |   23 +++++++++++++++++++++++
> >  arch/x86/include/asm/xsave.h     |    6 +++++-
> >  2 files changed, 28 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/processor.h
> > b/arch/x86/include/asm/processor.h
> > index 987c75e..43be6f6 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -370,6 +370,26 @@ struct ymmh_struct {
> >  	u32 ymmh_space[64];
> >  };
> >
> > +struct lwp_struct {
> > +	u64 lwpcb_addr;
> > +	u32 flags;
> > +	u32 buf_head_offset;
> > +	u64 buf_base;
> > +	u32 buf_size;
> > +	u32 filters;
> > +	u64 saved_event_record[4];
> > +	u32 event_counter[16];
> > +};
> > +
> > +struct bndregs_struct {
> > +	u64 bndregs[8];
> > +} __packed;
> > +
> > +struct bndcsr_struct {
> > +	u64 cfg_reg_u;
> > +	u64 status_reg;
> > +} __packed;
> > +
> >  struct xsave_hdr_struct {
> >  	u64 xstate_bv;
> >  	u64 reserved1[2];
> > @@ -380,6 +400,9 @@ struct xsave_struct {
> >  	struct i387_fxsave_struct i387;
> >  	struct xsave_hdr_struct xsave_hdr;
> >  	struct ymmh_struct ymmh;
> > +	struct lwp_struct lwp;
> 
> I'm guessing this and the struct lwp_struct above is being added so that you
> can have the LWP XSAVE area size? If so, you don't need it: LWP XSAVE area is
> 128 bytes at offset 832 according to my manuals so I'd guess having a u8
> lwp_area[128] should be fine.
> 
Yes, currently it is only for the LWP XSAVE area size. I will directly use a u8 lwp_area[128].

> 
> > +	struct bndregs_struct bndregs;
> > +	struct bndcsr_struct bndcsr;
> >  	/* new processor state extensions will go here */  } __attribute__
> > ((packed, aligned (64)));
> >
> > diff --git a/arch/x86/include/asm/xsave.h
> > b/arch/x86/include/asm/xsave.h index 0415cda..5cd9de3 100644
> > --- a/arch/x86/include/asm/xsave.h
> > +++ b/arch/x86/include/asm/xsave.h
> > @@ -9,6 +9,8 @@
> >  #define XSTATE_FP	0x1
> >  #define XSTATE_SSE	0x2
> >  #define XSTATE_YMM	0x4
> > +#define XSTATE_BNDREGS	0x8
> > +#define XSTATE_BNDCSR	0x10
> >
> >  #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
> >
> > @@ -20,10 +22,12 @@
> >  #define XSAVE_YMM_SIZE	    256
> >  #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE +
> XSAVE_HDR_OFFSET)
> >
> > +#define XSTATE_FLEXIBLE (XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
> 
> What's the use of that macro if it is used only once?
> 
Yes. Maybe it is best to use previous pattern.

> > +#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
> >  /*
> >   * These are the features that the OS can handle currently.
> >   */
> > -#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
> > +#define XCNTXT_MASK	(XSTATE_FLEXIBLE | XSTATE_EAGER)
> >
> >  #ifdef CONFIG_X86_64
> >  #define REX_PREFIX	"0x48, "
> 
Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
