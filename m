Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3IPVzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:55:50 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:52201
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3IPVzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:55:48 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOspfSNoWHhKt7u0WqPY6XUwHbdJnIBjYAgABmTaCAAArAAIAAC6BwgAAXC4CAABPrMIAAA2WAgAABSXCAABqyAIAADG8Q
Date: Mon, 16 Sep 2013 21:55:44 +0000
Message-ID: <a76e49ef4b7f44f9a99acea5295d1491@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916082110.GN25896@mwanda>
 <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916150548.GO25896@mwanda>
 <baabf219b12b40de8e17b029e621e079@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916170951.GB20734@core.coreip.homeip.net>
 <3e45f054c6e243eabf2896ab1dcf38d4@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916183319.GM19256@mwanda>
 <117fbf407a554684b4d72ab06b033eeb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916201328.GN19256@mwanda>
In-Reply-To: <20130916201328.GN19256@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::5]
x-forefront-prvs: 0971922F40
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(189002)(199002)(377454003)(13464003)(24454002)(74706001)(69226001)(81342001)(31966008)(74662001)(53806001)(80022001)(81542001)(74502001)(83072001)(46102001)(19580395003)(83322001)(19580405001)(47446002)(51856001)(74876001)(54316002)(4396001)(56776001)(49866001)(47976001)(47736001)(33646001)(77982001)(77096001)(81816001)(81686001)(59766001)(56816003)(80976001)(54356001)(79102001)(65816001)(76796001)(76786001)(50986001)(63696002)(76576001)(76482001)(74316001)(74366001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::5;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, September 16, 2013 1:13 PM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com; Dmitry
> Torokhov; linux-kernel@vger.kernel.org; vojtech@suse.cz; linux-
> input@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> On Mon, Sep 16, 2013 at 06:42:25PM +0000, KY Srinivasan wrote:
> > Dan,
> >
> > Rolling the changes you have indicated is not the issue; this can trivially be
> done.
> > My contention is that it is not needed given that the underlying function is
> already
> > doing that. Look at the function  vmbus_recvpacket_raw() in
> drivers/hv/channel.c.
> >
> 
> I'm confused.
> 
> There is no mention of ->offset8 in vmbus_recvpacket_raw().

As you can see the vmbus_recvpacket_raw() ensures that the complete
packet is read and if the buffer specified is not large enough nothing is 
read. The packet header has information about the length of the packet
and the offset where the payload is.  
> 
> It's a good idea to add a check there but the lower levels don't know
> about the sizeof(synth_kbd_protocol_response) so we would still need
> something like my check.

Why would the lower level code need to know  anything about the layout of a
particular message type. The lower level code is guaranteeing that a complete
packet has been read in and that should be sufficient - assuming we trust the host.

We have already spent more time on this than we should; I will make the necessary
changes.

Regards,

K. Y
> 
> regards,
> dan carpenter

