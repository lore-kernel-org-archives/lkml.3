Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282Ab3BSVBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:01:43 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:58325 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171Ab3BSVBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:01:41 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: RE: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac4DKenvaw7irpCHQuCAh5bLR9M+cAI2fG6AAAPXLoAAAGoYgAAAYjMAAIaQEGAACvYIAAAJmAMAAACG24AAABJ6gAAXt+Pw
Date: Tue, 19 Feb 2013 21:00:45 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414ACBC2D@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
	    <511ECE53.8040801@zytor.com>
	   <1360979993.23152.122.camel@gandalf.local.home>
	   <511EEAE1.1040106@zytor.com>
	  <1360981364.23152.123.camel@gandalf.local.home>
	  <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>
	  <5122BE0C.9020403@zytor.com>
	 <1361247854.23152.198.camel@gandalf.local.home>
	 <512301F7.4020709@zytor.com> <1361248883.23152.199.camel@gandalf.local.home>
In-Reply-To: <1361248883.23152.199.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-19_04:2013-02-19,2013-02-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302190204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I will update my patch.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Tuesday, February 19, 2013 1:41 PM
> To: H. Peter Anvin
> Cc: Seiji Aguchi; x86@kernel.org; linux-kernel@vger.kernel.org; Thomas Gleixner (tglx@linutronix.de); 'mingo@elte.hu'
> (mingo@elte.hu); Borislav Petkov (bp@alien8.de); Satoru Moriya; dle-develop@lists.sourceforge.net; linux-edac@vger.kernel.org;
> Luck, Tony (tony.luck@intel.com)
> Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
> 
> On Mon, 2013-02-18 at 20:39 -0800, H. Peter Anvin wrote:
> 
> > > static void switch_to_trace_idt(void *arg) {
> > >      load_idt(&trace_idt_descr);
> > > }
> > >
> > > static void restore_original_idt(void *arg) {
> > >      load_idt(this_cpu_ptr(&idt_descr));
> > > }
> > >
> >
> > Yes.  If there needs to be handshaking about whose IDT is currently
> > installed I'm much happier if that handshake is done explicitly,
> > rather than as a save/restore function which will break when we have
> > to add another one which for whatever reason isn't nesting.
> 
> Agreed.
> 
> Seiji, can you make the update?
> 
> Thanks,
> 
> -- Steve
> 

