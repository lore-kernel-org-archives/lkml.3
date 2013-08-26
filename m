Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3HZXDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 19:03:44 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:57580
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751634Ab3HZXDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 19:03:43 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 19:03:43 EDT
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Thread-Index: AQHOoprZO3vQBjcbS0OW+8HWuT6PHZmoCSYAgAAFNMA=
Date: Mon, 26 Aug 2013 22:48:16 +0000
Message-ID: <240d7113f9cd4862a44bd5d6a7751ca0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1377551338-29582-1-git-send-email-kys@microsoft.com>
 <20130826215656.GA2276@kroah.com>
In-Reply-To: <20130826215656.GA2276@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0950706AC1
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(199002)(189002)(51704005)(24454002)(377454003)(46102001)(63696002)(79102001)(77982001)(59766001)(51856001)(19580405001)(83322001)(76796001)(81686001)(50986001)(76786001)(81816001)(4396001)(33646001)(49866001)(83072001)(19580395003)(74366001)(81542001)(69226001)(74876001)(53806001)(56776001)(47976001)(74316001)(47736001)(76482001)(54316002)(77096001)(80022001)(80976001)(76576001)(65816001)(56816003)(54356001)(47446002)(74502001)(74662001)(74706001)(31966008)(81342001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, August 26, 2013 2:57 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of channel
> offers
> 
> On Mon, Aug 26, 2013 at 02:08:58PM -0700, K. Y. Srinivasan wrote:
> > The channel state should be correctly set before registering the device. In the
> current
> > code the driver probe would fail for channels that have been rescinded and
> subsequently
> > re-offered. Fix the bug.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Cc: <stable@vger.kernel.org>
> 
> What older kernel versions have this bug?  When did it show up?

The patch that introduced the bug is:

commit e68d2971d26577b932a16333ce165af98a96e068
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Thu May 23 12:02:32 2013 -0700

    Drivers: hv: vmbus: Implement multi-channel support

I think 3.10 shipped with this bug.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
