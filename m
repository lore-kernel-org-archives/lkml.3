Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3IPPwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:52:23 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:57341
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040Ab3IPPwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:52:22 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOspfSNoWHhKt7u0WqPY6XUwHbdJnIe1MAgAAFTNA=
Date: Mon, 16 Sep 2013 15:52:18 +0000
Message-ID: <076938490f5141ef957947dc10b82c65@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916152019.GB12105@core.coreip.homeip.net>
In-Reply-To: <20130916152019.GB12105@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0971922F40
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(13464003)(24454002)(51704005)(199002)(189002)(80976001)(54356001)(77982001)(77096001)(76576001)(59766001)(56816003)(81816001)(81686001)(79102001)(65816001)(74366001)(76482001)(74316001)(76786001)(76796001)(50986001)(63696002)(46102001)(83072001)(74502001)(51856001)(19580405001)(83322001)(19580395003)(47446002)(74662001)(31966008)(69226001)(74706001)(81342001)(81542001)(80022001)(53806001)(66066001)(54316002)(4396001)(74876001)(49866001)(47736001)(47976001)(33646001)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Monday, September 16, 2013 8:20 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; linux-input@vger.kernel.org; vojtech@suse.cz;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> Hi K. Y.
> 
> On Sun, Sep 15, 2013 at 10:28:54PM -0700, K. Y. Srinivasan wrote:
> > Add a new driver to support synthetic keyboard. On the next generation
> > Hyper-V guest firmware, many legacy devices will not be emulated and this
> > driver will be required.
> >
> > I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> > details of the AT keyboard driver.
> >
> 
> In addition to what Dan said:
> 
> > +
> > +struct synth_kbd_protocol_response {
> > +	struct synth_kbd_msg_hdr header;
> > +	u32 accepted:1;
> > +	u32 reserved:31;
> > +};
> 
> Use of bitfields for on the wire structures makes me uneasy. I know that
> currently you only going to run LE on LE, but still, maybe using
> explicit shifts and masks would be better,

This definition of the data structure is defined by the host. I will see what I
can do here.

> 
> > +
> > +struct synth_kbd_keystroke {
> > +	struct synth_kbd_msg_hdr header;
> > +	u16 make_code;
> > +	u16 reserved0;
> > +	u32 is_unicode:1;
> > +	u32 is_break:1;
> > +	u32 is_e0:1;
> > +	u32 is_e1:1;
> > +	u32 reserved:28;
> > +};
> 
> Same here.
> 
> > +
> > +
> > +#define HK_MAXIMUM_MESSAGE_SIZE 256
> > +
> > +#define KBD_VSC_SEND_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
> > +#define KBD_VSC_RECV_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
> > +
> > +#define XTKBD_EMUL0     0xe0
> > +#define XTKBD_EMUL1     0xe1
> > +#define XTKBD_RELEASE   0x80
> > +
> > +
> > +/*
> > + * Represents a keyboard device
> > + */
> > +struct hv_kbd_dev {
> > +	unsigned char keycode[256];
> 
> I do not see anything using keycode table? This is wrong level for it
> regardless.
> 
> > +	struct hv_device	*device;
> > +	struct synth_kbd_protocol_request protocol_req;
> > +	struct synth_kbd_protocol_response protocol_resp;
> > +	/* Synchronize the request/response if needed */
> > +	struct completion	wait_event;
> > +	struct serio		*hv_serio;
> > +};
> > +
> > +
> > +static struct hv_kbd_dev *hv_kbd_alloc_device(struct hv_device *device)
> > +{
> > +	struct hv_kbd_dev *kbd_dev;
> > +	struct serio	*hv_serio;
> 
> You are aligning with tabs half of declarations, leaving the others. Can
> we not align at all?
> 
> > +
> > +	kbd_dev = kzalloc(sizeof(struct hv_kbd_dev), GFP_KERNEL);
> > +
> > +	if (!kbd_dev)
> > +		return NULL;
> > +
> > +	hv_serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> > +
> > +	if (hv_serio == NULL) {
> > +		kfree(kbd_dev);
> > +		return NULL;
> > +	}
> > +
> > +	hv_serio->id.type	= SERIO_8042_XL;
> > +	strlcpy(hv_serio->name, dev_name(&device->device),
> > +		sizeof(hv_serio->name));
> > +	strlcpy(hv_serio->phys, dev_name(&device->device),
> > +		sizeof(hv_serio->phys));
> > +	hv_serio->dev.parent  = &device->device;
> 
> Do you also want to set up serio's parent device to point to hv device?

Is there an issue here; I could setup the parent as the vmbus device.

> 
> > +
> > +
> > +	kbd_dev->device = device;
> > +	kbd_dev->hv_serio = hv_serio;
> > +	hv_set_drvdata(device, kbd_dev);
> > +	init_completion(&kbd_dev->wait_event);
> > +
> > +	return kbd_dev;
> > +}
> > +
> > +static void hv_kbd_free_device(struct hv_kbd_dev *device)
> > +{
> > +	serio_unregister_port(device->hv_serio);
> > +	kfree(device->hv_serio);
> 
> Serio ports are refcounted, do not free them explicitly after they have
> been registered.

Thank you. I will fix this.

> 
> > +	hv_set_drvdata(device->device, NULL);
> > +	kfree(device);
> > +}
> 
> 
> Thanks.


Thank you!.

Regards,

K. Y
