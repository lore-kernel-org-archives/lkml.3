Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaBTW0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:26:50 -0500
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:40059
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752412AbaBTW0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:26:48 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AACFkLgAAKotuAAAWAAA==
Date: Thu, 20 Feb 2014 22:26:45 +0000
Message-ID: <1392935204.20109.17.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
	 <20140220220656.GT17949@sgi.com>
In-Reply-To: <20140220220656.GT17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(51704005)(377424004)(199002)(189002)(77096001)(81816001)(47446002)(81686001)(56816005)(63696002)(81542001)(74366001)(90146001)(85306002)(79102001)(74662001)(31966008)(74502001)(76796001)(95666003)(87266001)(87936001)(81342001)(33716001)(33646001)(74706001)(74876001)(94316002)(92566001)(85852003)(77982001)(69226001)(47976001)(49866001)(50986001)(47736001)(76482001)(56776001)(4396001)(54316002)(54356001)(53806001)(51856001)(95416001)(19580405001)(19580395003)(59766001)(76786001)(2656002)(83322001)(46102001)(83072002)(65816001)(80022001)(80976001)(93136001)(92726001)(93516002)(94946001)(86362001)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:FC8CF5EB.BC3217E9.71F8B982.46E6D903.202DD;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A925D6350B0FB047B6F3A53B43B289A1@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KMQvN6022365

On Thu, 2014-02-20 at 16:06 -0600, Russ Anderson wrote:
> On Thu, Feb 20, 2014 at 09:39:23PM +0000, Matthew Garrett wrote:
> > On Thu, 2014-02-20 at 15:28 -0600, Russ Anderson wrote:
> > 
> > > For some customers _any_ amount is significant, especially
> > > on large clustered systems where the amount is multiplied
> > > by tens or hundreds of thousands of nodes.
> > > 
> > > You many not think wasting their cpu cycles is important, but they do.
> > 
> > Then they should be running locally built kernels in order to ensure
> 
> Why don't YOU run a locally built kernel?

Because I'm trying to ensure that the default behaviour of the kernel is
to *work*. Defaulting to having IPMI be modular means that the default
behaviour of the kernel, as far as the ACPI spec goes, is to be broken.

>> If you have specific bug reports, that would be helpful. But you're not
> > describing actual failure conditions or showing any willingness to
> > figure out what the underlying problem is.
> 
> You can't fix your problem without creating problems for
> others to fix?

ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
that the kernel will spend a significant amount of time (potentially
until a user manually loads a driver) failing to implement part of the
IPMI specification. That's a problem, and the correct fix is to ensure
that the kernel always implements IPMI support.

Now, you've described some other problems. I don't disagree that those
are problems. The correct thing for us to do with those problems is to
fix them, not to simply change the kernel defaults such that it's
possible for users to choose between two differently broken states. I'm
absolutely willing to help, as long as you're willing to put some
reasonable amount of effort into describing them.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
