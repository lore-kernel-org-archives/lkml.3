Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3EaLC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:02:59 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:13256 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754879Ab3EaLCx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:02:53 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 May 2013 19:02:49 +0800
Subject: RE: A bug about system call on ARM
Thread-Topic: A bug about system call on ARM
Thread-Index: Ac5d23iAem8cNgvkR5OYkbUQGstpXQAEQ3wA
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B874@CNBJMBX05.corpusers.net>
References: <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B86D@CNBJMBX05.corpusers.net>
 <20130531084638.GB4928@mudshark.cambridge.arm.com>
In-Reply-To: <20130531084638.GB4928@mudshark.cambridge.arm.com>
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

Hi  Will,

I have merge your code ,
But there is a different ,

+	
+	ct_user_exit
+
+#ifdef CONFIG_ALIGNMENT_TRAP
+	ldr	ip, __cr_alignment
+	ldr	ip, [ip]
+	mcr	p15, 0, ip, c1, c0		@ update control register
+#endif 

+	enable_irq
+	get_thread_info tsk

Is this change ok ?


Thanks 

-----Original Message-----
From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Will Deacon
Sent: Friday, May 31, 2013 4:47 PM
To: Wang, Yalin
Cc: 'richard -rw- weinberger'; 'linux-arch@vger.kernel.org'; 'linux-kernel@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'
Subject: Re: A bug about system call on ARM

On Fri, May 31, 2013 at 03:56:31AM +0100, Wang, Yalin wrote:
> Hi Will,
> 
> Thanks for your patch ,
> 
> But I found  I don't have ct_user_exit  macro In my 
> arch/arm/kernel/entry-common.S
> 
> My kernel version is 3.4.0

Well things have moved on this since then (we're approaching 3.10, so you might consider an upgrade!).

For the purposes of this patch, you can just delete the ct_user_exit line.

Will
--
To unsubscribe from this list: send the line "unsubscribe linux-arch" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
