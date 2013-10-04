Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3JDPCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:02:41 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:34251
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977Ab3JDPCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:02:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Eric Seppanen <eric@purestorage.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJggAU49YCAAAdE0IAAT/uAgABKyICAALYxAIALo8YggAEpLYCAAJEwAIABKPOw
Date: Fri, 4 Oct 2013 15:02:18 +0000
Message-ID: <2cc1bcb3a157418eb66bd2d91cf911c1@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com>
 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <5241C9E7.2000404@cs.wisc.edu>
 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
 <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
 <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
In-Reply-To: <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(24454002)(377454003)(51704005)(13464003)(377424004)(56776001)(74706001)(33646001)(76482001)(63696002)(49866001)(50986001)(4396001)(53806001)(51856001)(69226001)(74366001)(79102001)(47736001)(85306002)(47976001)(81686001)(46102001)(54356001)(66066001)(80976001)(80022001)(77982001)(59766001)(54316002)(65816001)(19580405001)(83072001)(83322001)(76796001)(74662001)(74502001)(47446002)(19580395003)(76576001)(77096001)(31966008)(56816003)(81542001)(81816001)(81342001)(74876001)(76786001)(74316001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eric Seppanen [mailto:eric@purestorage.com]
> Sent: Thursday, October 03, 2013 1:49 PM
> To: Nicholas A. Bellinger
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> linux-scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Thu, Oct 3, 2013 at 5:09 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> > > Ideally, I want this to be adjustable like the way we can change the I/O
> timeout.
> > > Since that has been attempted earlier and rejected (not clear what the
> reasons were),
> > > I was suggesting that we pick a larger number. James, let me know how I
> should proceed here.
> > >
> >
> > I think the objection was to making a module parameter for doing this
> > globally for all struct scsi_disk, and not the idea of making it
> > adjustable on an individual basis per-say..
> >
> > What about adding a /sys/class/scsi_disk/$HCTL/flush_timeout..?
> 
> Do I/O timeouts and flush timeouts need to be independently adjusted?
> If you're having trouble with slow operations, it seems likely to be
> across the board.
> 
> Flush timeout could be defined as 2x the read/write timeout.  Any
> other command-specific timeouts could be scaled the same way.

I like this idea and would result in minimal changes. James, if it ok with you,
I could send you the patch.

Regards,

K. Y
