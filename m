Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3IUFZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 01:25:44 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:46209
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039Ab3IUFZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 01:25:42 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJg
Date: Sat, 21 Sep 2013 05:24:57 +0000
Message-ID: <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
In-Reply-To: <20130920203222.GA14306@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 09760A0505
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(377454003)(51704005)(13464003)(189002)(199002)(74366001)(33646001)(65816001)(76786001)(77982001)(76576001)(56816003)(81686001)(51856001)(76796001)(74316001)(54356001)(83072001)(77096001)(19580395003)(80022001)(46102001)(47736001)(74876001)(81342001)(69226001)(81542001)(74706001)(66066001)(4396001)(76482001)(63696002)(31966008)(47976001)(81816001)(83322001)(50986001)(19580405001)(53806001)(59766001)(79102001)(47446002)(74502001)(54316002)(49866001)(56776001)(80976001)(74662001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, September 20, 2013 1:32 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> > The SD_FLUSH_TIMEOUT value is currently hardcoded.
> 
> Hardcoded where?  Please, more context.

This is defined in scsi/sd.h:

#define SD_FLUSH_TIMEOUT        (60 * HZ)
> 
> > On our cloud, we sometimes hit this timeout. I was wondering if we
> > could make this a module parameter. If this is acceptable, I can send
> > you a patch for this.
> 
> A module parameter don't make sense for a per-device value, does it?
Currently, the 60 second timeout is applied across devices. Ideally, I want to be
able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is 
acceptable, I can work on a patch for that as well.

Regards,

K. Y
> 
> greg k-h
