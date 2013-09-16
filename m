Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3IPQ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:56:10 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:35634
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750932Ab3IPQ4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:56:07 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOspfSNoWHhKt7u0WqPY6XUwHbdJnIBjYAgABmTaCAAArAAIAAC6Bw
Date: Mon, 16 Sep 2013 16:56:03 +0000
Message-ID: <baabf219b12b40de8e17b029e621e079@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916082110.GN25896@mwanda>
 <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916150548.GO25896@mwanda>
In-Reply-To: <20130916150548.GO25896@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0971922F40
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(377454003)(189002)(199002)(13464003)(24454002)(83072001)(80022001)(74876001)(69226001)(81342001)(19580405001)(83322001)(19580395003)(46102001)(51856001)(74706001)(81542001)(53806001)(4396001)(76482001)(54316002)(56776001)(49866001)(47736001)(33646001)(47976001)(74502001)(74662001)(31966008)(47446002)(76576001)(74316001)(76786001)(65816001)(77096001)(80976001)(76796001)(56816003)(59766001)(77982001)(81686001)(79102001)(54356001)(63696002)(81816001)(50986001)(74366001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, September 16, 2013 8:06 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org; vojtech@suse.cz;
> linux-input@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> On Mon, Sep 16, 2013 at 02:46:24PM +0000, KY Srinivasan wrote:
> > > > +			case VM_PKT_DATA_INBAND:
> > > > +				hv_kbd_on_receive(device, desc);
> > >
> > > This is the error handling I mentioned at the top.  hv_kbd_on_receive()
> > > doesn't take into consideration the amount of data we recieved, it
> > > trusts the offset we recieved from the user.  There is an out of bounds
> > > read.
> >
> > What user are you referring to. The message is sent by the host - the user
> keystroke
> > is normalized into a fixed size packet by the host and sent to the  guest. We will
> parse this
> > packet, based on the host specified layout here.
> >
> 
> The user means the hypervisor, yes.
> 
> I don't want the hypervisor accessing outside of the buffer.  It is
> robustness issue.  Just check the offset against "bytes_recvd".  It's
> not complicated.

At the outset, let me apologize for not understanding your concern.
You say: " I don't want the hypervisor accessing outside of the buffer"
Where did you see the hypervisor accessing anything outside the buffer?
The buffer is allocated by this driver and a packet from vmbus is read into this
buffer - this is the call to vmbus_recvpacket(). If the specified buffer is smaller
than the packet that needs to be read, then nothing will be read. Once the read
completes, we can be sure we have read a valid packet and can proceed to parse it in
this driver.

I don't want to be argumentative, I am just not seeing the issue.

Regards,

K. Y
 
