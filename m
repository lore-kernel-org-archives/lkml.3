Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3IQSmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:42:36 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:24806
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753055Ab3IQSmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:42:35 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Topic: [PATCH 00/13] hv: clean up dev_attr usage
Thread-Index: AQHOsK+1mcM+7wT8AkG+31wmWIBnRpnKSIeQ
Date: Tue, 17 Sep 2013 18:42:30 +0000
Message-ID: <654a20fac822400798f991f33b699018@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-forefront-prvs: 0972DEC1D9
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(377454003)(13464003)(199002)(189002)(74366001)(79102001)(65816001)(76786001)(81686001)(81816001)(80976001)(1511001)(77096001)(54356001)(59766001)(56816003)(74316001)(76482001)(76796001)(63696002)(50986001)(77982001)(76576001)(83072001)(31966008)(83322001)(19580395003)(47446002)(19580405001)(74662001)(74502001)(51856001)(69226001)(74706001)(81342001)(81542001)(80022001)(53806001)(74876001)(46102001)(54316002)(4396001)(47736001)(56776001)(49866001)(47976001)(33646001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ee43::3;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, September 13, 2013 11:33 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 00/13] hv: clean up dev_attr usage
> 
> Hi,
> 
> Here's a set of 13 patches to get rid of the dev_attrs use in the hv bus
> code, as it will be going away soon.  It's _way_ bigger than all other
> conversions I've had to do so far in the kernel, as you were using a
> "multiplexor" function for all of these files.
> 
> So, I've broken it up into individual show/store sysfs functions, and
> cleaned up a bunch of debug structures that aren't needed and shouldn't
> be exported to the rest of the kernel.
> 
> I've also fixed up some void * usage in the hv core, in patch 07, to
> make things simpler and not so "magic" when dealing with these pages.
> If you could review that one closely to ensure I didn't mess anything
> up, I would appreciate it.
> 
> Also, are all of these files really needed for sysfs?  They seem to be
> all debugging stuff, shouldn't they go into debugfs if you really
> need/use them anymore?
> 
> KY, could you test these out?  I don't have access to a hv system at the
> moment.  I'll wait for your ack before applying them to any of my trees.

The patches look good and I tested them. The guest comes up and is functional.
I did notice though that the pending state appears to be a signed entity now which was not the
the case  before - I see a negative sign when I cat the client/server pending state.

Regards,

K. Y 
> 
> thanks,
> 
> greg k-h

