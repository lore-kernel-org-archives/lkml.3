Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3IRX2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:28:15 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:46260
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511Ab3IRX2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:28:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>
Subject: RE: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOs/eVPipjOSapYkq/ifTO5i21spnL/HUAgAAj11A=
Date: Wed, 18 Sep 2013 23:27:51 +0000
Message-ID: <304cbdeb0aa34f9a9ba6b44828fb5647@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com>
 <20130918210107.GA32320@core.coreip.homeip.net>
In-Reply-To: <20130918210107.GA32320@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::2]
x-forefront-prvs: 09730BD177
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(24454002)(13464003)(199002)(51704005)(189002)(81686001)(76482001)(77982001)(59766001)(54316002)(56776001)(33646001)(81816001)(74502001)(31966008)(47446002)(74662001)(46102001)(51856001)(74706001)(53806001)(74876001)(19580395003)(19580405001)(83322001)(49866001)(74316001)(50986001)(47976001)(47736001)(74366001)(4396001)(80976001)(83072001)(63696002)(54356001)(76786001)(76796001)(76576001)(69226001)(77096001)(56816003)(80022001)(81542001)(79102001)(65816001)(81342001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ee31::2;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, September 18, 2013 2:01 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; dan.carpenter@oracle.com; linux-
> input@vger.kernel.org; vojtech@suse.cz
> Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> Hi K.Y.,
> 
> On Tue, Sep 17, 2013 at 04:26:58PM -0700, K. Y. Srinivasan wrote:
> > Add a new driver to support synthetic keyboard. On the next generation
> > Hyper-V guest firmware, many legacy devices will not be emulated and this
> > driver will be required.
> >
> > I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> > details of the AT keyboard driver. I would also like to thank
> > Dan Carpenter <dan.carpenter@oracle.com> and
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> for their detailed review of
> this
> > driver.
> >
> > I have addressed all the comments of Dan and Dmitry in this version of
> > the patch
> 
> This looks much better. Could you tell me if the patch below (on top of
> yours) still works?
> 
> Thanks.

Thank you. The code looks much better now. You forgot to initialize the port_data and
after I fixed that everything seems to work as it did before: Here is the patch I used:

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Wednesday, September 18, 2013 4:50 PM
> To: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: input: serio: hyper-V: Initialize the port data
> correctly
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/input/serio/hyperv-keyboard.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-
> keyboard.c
> index 401fbdd..aff4152 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -351,6 +351,7 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
> 
>  	hv_serio->dev.parent  = &hv_dev->device;
>  	hv_serio->id.type = SERIO_8042_XL;
> +	hv_serio->port_data = kbd_dev;
>  	strlcpy(hv_serio->name, dev_name(&hv_dev->device),
>  		sizeof(hv_serio->name));
>  	strlcpy(hv_serio->phys, dev_name(&hv_dev->device),
> --
> 1.7.4.1


Once again; thank you for all your help.

Regards,

K. Y

