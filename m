Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaDLCqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 22:46:30 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:15038
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754438AbaDLCq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 22:46:28 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: RE: [PATCH V1 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Topic: [PATCH V1 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Index: AQHPVeGCk3d5oIQvZEiA/cAVWdUh2psNGFyAgAAueFA=
Date: Sat, 12 Apr 2014 02:46:23 +0000
Message-ID: <4ffa16b7f32449d2b445054ce8a51d9e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397263802-5934-1-git-send-email-kys@microsoft.com>
 <534881DB.40901@zytor.com>
In-Reply-To: <534881DB.40901@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:7c67:871b:cd27:65d2]
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(13464003)(51704005)(164054003)(479174003)(377454003)(189002)(199002)(2656002)(83072002)(81342001)(83322001)(76576001)(81542001)(99396002)(19580395003)(19580405001)(99286001)(74502001)(85852003)(74316001)(46102001)(79102001)(4396001)(86612001)(86362001)(87936001)(76482001)(33646001)(31966008)(80022001)(74662001)(2201001)(54356999)(50986999)(76176999)(77982001)(92566001)(80976001)(20776003)(77096999)(921003)(1121002)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:BCCFF902.9B32AD1A.38E3F3B3.48EDC93B.20232;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3C2lRns008141



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Friday, April 11, 2014 4:59 PM
> To: KY Srinivasan; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com
> Subject: Re: [PATCH V1 1/1] X86: Probe for PIC and set legacy_pic
> appropriately
> 
> On 04/11/2014 05:50 PM, K. Y. Srinivasan wrote:
> >
> > +	/*
> > +	 * Check to see if we have a PIC.
> > +	 * Mask all except the cascade and read
> > +	 * back the value we just wrote. If we don't
> > +	 * have a PIC, we will read 0xff as opposed to the
> > +	 * value we wrote.
> > +	 */
> > +	outb(probe_val, PIC_MASTER_IMR);
> > +	probe_val = inb(PIC_MASTER_IMR);
> > +	if (probe_val == 0xff) {
> > +		printk(KERN_INFO "Using NULL legacy PIC\n");
> > +		legacy_pic = &null_legacy_pic;
> > +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> > +		return;
> > +	}
> > +
> >  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
> >  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
> >
> 
> Again, I would do at least the slave masking above the probe.
> 
> Also, I would compare to make sure we get the probe_val back and compare
> with != instead of comparing with ==.

Will do.

Thanks,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
