Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaJaH7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:59:42 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:10421 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaJaH7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:59:41 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Joe Perches'" <joe@perches.com>
CC: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 15:59:37 +0800
Subject: RE: [RFC] arm:remove clear_thread_flag(TIF_UPROBE)
Thread-Topic: [RFC] arm:remove clear_thread_flag(TIF_UPROBE)
Thread-Index: Ac/04G2Oik0iMWuUSRi4S5gJBTWE9AAAB5BA
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1827E@CNBJMBX05.corpusers.net>
References: <1414392371.8884.2.camel@perches.com>
	 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
	 <20141030120127.GC32589@arm.com>
	 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
	 <20141030135749.GE32589@arm.com>
	 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D1827B@CNBJMBX05.corpusers.net>
	 <1414741535.8928.2.camel@perches.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1827C@CNBJMBX05.corpusers.net>
 <1414742289.8928.5.camel@perches.com>
In-Reply-To: <1414742289.8928.5.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
> > > > @@ -591,10 +591,9 @@ do_work_pending(struct pt_regs *regs, unsigned
> int
> > > thread_flags, int syscall)
> > > >  					return restart;
> > > >  				}
> > > >  				syscall = 0;
> > > > -			} else if (thread_flags & _TIF_UPROBE) {
> > > > -				clear_thread_flag(TIF_UPROBE);
> > > > +			} else if (thread_flags & _TIF_UPROBE)
> > > >  				uprobe_notify_resume(regs);
> > > > -			} else {
> > > > +			else {
> > > >  				clear_thread_flag(TIF_NOTIFY_RESUME);
> > > >  				tracehook_notify_resume(regs);
> > > >  			}
> > >
> > > Please keep the braces.
> >
> > mm..  could I know the reason ?  :)
> 
> Try read Documentation/CodingStyle
> 
> 		Chapter 3: Placing Braces and Spaces
> 
> use braces in both branches:
> 
> if (condition) {
> 	do_this();
> 	do_that();
> } else {
> 	otherwise();
> }
> 

Got it,  I will resend one .
Thanks

