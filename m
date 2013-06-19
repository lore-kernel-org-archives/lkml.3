Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262Ab3FSVCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:02:21 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:56878 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:02:18 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: RE: [PATCH v16 4/4] trace,x86: Add irq vector tracepoints
Thread-Topic: [PATCH v16 4/4] trace,x86: Add irq vector tracepoints
Thread-Index: AQHObFZ1xxOEHR0zmk+cqogyEFgMNJk9yVMA//++AvA=
Date: Wed, 19 Jun 2013 21:01:20 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B04BAA8@USINDEM103.corp.hds.com>
References: <51C0ADA6.8040801@hds.com> <51C0AE77.3030907@hds.com>
 <1371675390.18733.70.camel@gandalf.local.home>
In-Reply-To: <1371675390.18733.70.camel@gandalf.local.home>
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
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-19_07:2013-06-19,2013-06-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=2 spamscore=2 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306190198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JL2Q2k012758


> On Tue, 2013-06-18 at 15:01 -0400, Seiji Aguchi wrote:
> >  /*
> >   * the load_current_idt() is called with interrupt disabled by
> > local_irq_save()
> >   * to avoid races. That way the IDT will always be set back to the
> > expected
> > @@ -442,6 +508,8 @@ static inline void load_current_idt(void)
> >         local_irq_save(flags);
> >         if (is_debug_idt_enabled())
> >                 load_debug_idt();
> > +       if (is_trace_idt_enabled())
> > +               load_trace_idt();
> 
> This should be:
> 
> 	else if (is_trace_idt_enabled())
> 
> Otherwise, you just totally negated the previous if.

Thank you for testing my patch.
I will fix it.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
