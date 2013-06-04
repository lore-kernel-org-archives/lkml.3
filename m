Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FDVCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:02:04 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:48599 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FDVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:02:00 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
Thread-Topic: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
Thread-Index: AQHOYJD5t4s5mkVepkqNMD/e2H+1XZkk7OKAgAE0KoCAAAStgP//2pQQgABODoD//71Q0A==
Date: Tue, 4 Jun 2013 21:01:09 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B011739@USINDEM103.corp.hds.com>
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com>
	 <1370303581.26799.109.camel@gandalf.local.home>
	 <51AE2EDF.3000505@zytor.com> <1370370763.9844.6.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41B011681@USINDEM103.corp.hds.com>
 <1370379489.9844.7.camel@gandalf.local.home>
In-Reply-To: <1370379489.9844.7.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-04_07:2013-06-04,2013-06-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306040211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r54L2CXp020814

OK, I will rename  debug_stack_use_ctr to debug_idt_ctr.
Thanks.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Tuesday, June 04, 2013 4:58 PM
> To: Seiji Aguchi
> Cc: H. Peter Anvin; linux-kernel@vger.kernel.org; x86@kernel.org; tglx@linutronix.de; mingo@elte.hu; bp@alien8.de; linux-
> edac@vger.kernel.org; tony.luck@intel.com; dle-develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
> 
> On Tue, 2013-06-04 at 20:20 +0000, Seiji Aguchi wrote:
> > Steven,
> >
> > >
> > > Hmm, maybe we can do it. Have two counters, a debug_idt_ctr and a
> > > trace_idt_ctr, then have a function that basically does this:
> > >
> > > 	if (this_cpu_read(debug_idt_ctr))
> >
> > I think we can use "debug_stack_use_ctr"  for the checking.
> > Is it correct?
> > Or, do I need to introduce a new debug_idt_ctr?
> >
> 
> No, it's the same variable. I was thinking we should rename it too, as
> debug_stack_use_ctr, doesn't really describe what is happening anymore.
> 
> -- Steve
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
