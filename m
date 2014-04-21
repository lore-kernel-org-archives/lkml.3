Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaDUG7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:59:35 -0400
Received: from [207.46.100.109] ([207.46.100.109]:49179 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbaDUG73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:59:29 -0400
X-Greylist: delayed 11018 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 02:59:29 EDT
From: Tien Hock Loh <thloh@altera.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Dinh Nguyen <dinguyen@altera.com>, Ley Foon Tan <lftan@altera.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "thloh.linux@gmail.com" <thloh.linux@gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
Thread-Topic: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
Thread-Index: AQHPXQhcsq16BvDmc0+h1Q5oLf7Jvg==
Date: Mon, 21 Apr 2014 02:21:11 +0000
Message-ID: <1CCADEFFEC58A54CACEDCA3F6E1E1A4C01573F@PG-ITEXCH02.altera.priv.altera.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
 <20140307151455.GI18529@joshc.qualcomm.com>
 <CAOLUe6aspffO1PUjKWW7ejpbxnYtb+RKRQrK=y30kuF7KXUUhA@mail.gmail.com>
 <CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
 <20140407171115.GA3956@joshc.qualcomm.com>
In-Reply-To: <20140407171115.GA3956@joshc.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.57.103.64]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(377454003)(377424004)(51164003)(24454002)(51704005)(189002)(199002)(66066001)(80022001)(92566001)(86362001)(80976001)(92726001)(4396001)(2656002)(81542001)(85852003)(83072002)(99396002)(33656001)(50986999)(87936001)(81342001)(97736001)(2009001)(23676002)(54356999)(55846006)(76176999)(74502001)(74662001)(31966008)(19580395003)(19580405001)(44976005)(83322001)(79102001)(6806004)(76482001)(77982001)(20776003)(47776003)(46102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB045;H:sj-itexedge03.altera.priv.altera.com;FPR:E722F066.9ED0571B.BCFB5DAF.80E0D08D.202F2;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0188D66E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3L6xhpr031065

On Isn, 2014-04-07 at 12:11 -0500, Josh Cartwright wrote:
> On Mon, Apr 07, 2014 at 04:00:43PM +0800, Tien Hock Loh wrote:
> > On Wed, Mar 19, 2014 at 6:09 PM, Tien Hock Loh <thloh@altera.com> wrote:
> > > On Fri, Mar 7, 2014 at 11:14 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> > >> On Mon, Mar 03, 2014 at 06:27:43PM +0800, thloh@altera.com wrote:
> > >>> From: Tien Hock Loh <thloh@altera.com>
> [..]
> > >>> +     altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
> > >>>
> > >>
> > >> platform_get_irq(pdev, 0);
> > >>
> > > OK.
> > >
> >
> > platform_get_irq doesn't create the irq mapping which is needed by the
> > driver. Since this driver is targeted at using of, should I be using
> > irq_of_parse_and_map or should I still redo the codes with
> > platform_get_irq and irq_create_mapping? I think the latter would be
> > introducing code redundancy. Please advice.
>
> Yes, it is technically true that platform_get_irq() doesn't do the
> mapping directly, but that's because the mapping is setup earlier, when
> of_device_alloc() (drivers/of/platform.c) allocates resources for your
> platform device.
>
> Calling irq_of_parse_and_map() should be unnecessary.

I checked and tried running the without irq_create_mapping but it seems
the mapping is not done. What I've seen other GPIO driver is doing is to
create the mapping during the gpio_to_irq call. However Linus suggested
we are avoiding that route, thus the use of irq_of_parse_and_map.

Do you agree with my findings?

>


________________________________

Confidentiality Notice.
This message may contain information that is confidential or otherwise protected from disclosure. If you are not the intended recipient, you are hereby notified that any use, disclosure, dissemination, distribution, or copying of this message, or any attachments, is strictly prohibited. If you have received this message in error, please advise the sender by reply e-mail, and delete the message and any attachments. Thank you.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
