Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaCNRzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:55:06 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:42047 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaCNRzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:55:04 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2014 13:55:04 EDT
X-ASG-Debug-ID: 1394819212-03d6a5419b34f950001-xx1T2L
X-Barracuda-Envelope-From: MChristie@fusionio.com
X-ASG-Whitelist: Client
Message-ID: <53234083.3060307@fusionio.com>
X-Barracuda-Apparent-Source-IP: 20.15.0.3
Date: Fri, 14 Mar 2014 12:46:43 -0500
From: Mike Christie <mchristie@fusionio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-man@vger.kernel.org>
Subject: Re: SuSE O_DIRECT|O_NONBLOCK overload
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de>	<20140312102849.GA26509@infradead.org> <53203BE5.402@suse.de>	<20140312110015.GA29907@infradead.org> <20140313111555.2f15f19f@notabene.brown>
X-ASG-Orig-Subj: Re: SuSE O_DIRECT|O_NONBLOCK overload
In-Reply-To: <20140313111555.2f15f19f@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.245.27.162]
X-ClientProxiedBy: BY2PR08CA017.namprd08.prod.outlook.com (10.242.234.165)
 To BLUPR04MB627.namprd04.prod.outlook.com (10.141.203.151)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(6049001)(428001)(377454003)(479174003)(189002)(199002)(24454002)(74366001)(81816001)(56816005)(80976001)(83072002)(85852003)(94946001)(92726001)(97336001)(97186001)(92566001)(53806001)(42186004)(76796001)(76786001)(83506001)(85306002)(87976001)(50466002)(94316002)(86362001)(93136001)(93516002)(83322001)(95416001)(81686001)(90146001)(95666003)(50986001)(74706001)(47976001)(46102001)(31966008)(47736001)(49866001)(79102001)(65806001)(65956001)(76482001)(74502001)(74662001)(47446002)(51856001)(64126003)(63696002)(47776003)(20776003)(36756003)(77096001)(56776001)(81542001)(54316002)(4396001)(23756003)(77982001)(59766001)(69226001)(81342001)(74876001)(54356001)(80022001)(66066001)(59896001)(62816006)(80792004);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR04MB627;H:[20.15.0.3];FPR:BFD4C6D2.7325415.C1DD477C.84C5EC90.2017A;MLV:nov;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Barracuda-Connect: UNKNOWN[10.101.1.41]
X-Barracuda-Start-Time: 1394819212
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 07:15 PM, NeilBrown wrote:
> I also think there should probably be just one FAILFAST flag.  Where it was
> the DEV or the TRANSPORT or the DRIVER that failed could be returned in the
> error code for any caller that cared.  But as I don't know why the one became
> three I could well be missing something important.

It was for multipath. The problem was dm-multipath does not know what to
do with low level device errors, but wanted transport errors returned
quickly. Other drivers like the scsi_dh (formerly dm hardware handlers)
modules, want all errors fast failed.

I can add documentation or we can just change the code to better suite
your needs.
