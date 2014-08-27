Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbaH0OPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:15:21 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:56952
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934726AbaH0OPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:15:19 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vhXWzggABBfwCAAQnBQIABpkoAgAAIh7CAABEjgIAAHqJw
Date: Wed, 27 Aug 2014 14:14:02 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
In-Reply-To: <20140827121559.GA14286@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(41574002)(13464003)(199003)(189002)(377454003)(51704005)(15975445006)(90102001)(23726002)(97736001)(97756001)(92566001)(86612001)(99396002)(68736004)(44976005)(83322001)(92726001)(76482001)(1411001)(74502001)(6806004)(31966008)(85852003)(19580395003)(16796002)(83072002)(69596002)(46102001)(46406003)(86362001)(4396001)(74662001)(20776003)(95666004)(2656002)(50466002)(54356999)(84676001)(106116001)(81542001)(77096002)(55846006)(81342001)(110136001)(26826002)(33656002)(87936001)(47776003)(50986999)(80022001)(76176999)(107046002)(85306004)(106466001)(21056001)(79102001)(77982001)(93886004)(81156004)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB190;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Wednesday, August 27, 2014 20:16 PM
> 
> > do_hypercall() fails due to HV_STATUS_INVALID_ALIGNMENT, if "the
> > specified input or output GPA pointer is not aligned to 8 bytes",
> > or, "the specified input or output parameter lists spans pages".
> > Here the 'input' can rarely across the page boundary, especially when
> > CONFIG_DEBUG_PAGEALLOC is on.
> 
> It can also be returned when "The input or output GPA pointer is not within
> the bounds of the GPA space." but I'm guessing that's not the case here?
Hi Sitsofe,
I think you're correct. 

> > I'm making a patch for this.
Please see the end of the mail for the inline patch and try it.
(the patch hasn't been rebased against KY's patchset)

> Thanks! Could these alignment problems have been the cause of all sorts
> of intermittent errors like https://lkml.org/lkml/2014/7/11/870 (which
> was caused by support being added for a bigger receive buffer)?
Probably, let's try the patch first. :-)

> > > I rebased your patch on top of the K.Y.'s "Drivers: hv: vmbus: Eliminate
> > > calls to BUG_ON()" patch set (see below). The combination no longer
> > > triggers the bug and it doesn't take too long to boot but the network
> > > interface fails to work (which I believe is .
> > the sentence is accidently trimmed here? :-)
> 
> *Cough* That bit in brackets shouldn't be there. I've been unable to
> link that stacktrace to an existing issue (I thought it might have been
> https://lkml.org/lkml/2014/8/19/227 but that seems unlikely).
I'm not 100% sure either.

> 
> > > Boot dmesg output (there's no line that mentions retries). The
> > > framebuffer window also didn't resize itself:
> > >
> > > [    7.848030] hv_vmbus: registering driver hyperv_fb
> > > [    7.859759] hyperv_fb: Unable to open vmbus channel
> > > [    7.871812] hyperv_fb: Unable to connect to VSP
> > We still see hyperv_fb can't work.
> 
> How come things didn't work even though the retries message (which is
> presumably printed if we exceed 10 attempts) was never printed?
the "10 attempts" doesn't handle HV_STATUS_INVALID_ALIGNMENT.

BTW, with the patch below, hyperv_fb can work now, BUT, *occasionally*,
storvsc_probe() -> ... -> vmbus_open() -> can fail due to
HV_STATUS_INVALID_ALIGNMENT...


diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 531a593..f5283a0 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -165,8 +165,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index edfc848..8366394 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -223,6 +223,9 @@ int hv_post_message(union hv_connection_id connection_id,
 	};
 
 	struct hv_input_post_message *aligned_msg;
+	unsigned long alighed_msg_start, alighed_msg_end;
+	bool need_free_aligned_msg = false;
+
 	u16 status;
 	unsigned long addr;
 
@@ -233,9 +236,30 @@ int hv_post_message(union hv_connection_id connection_id,
 	if (!addr)
 		return -ENOMEM;
 
+	/*
+	 * According to Hypervisor Top Level Functional Specification,
+	 * do_hypercall() fails due to HV_STATUS_INVALID_ALIGNMENT, if "the
+	 * specified input or output GPA pointer is not aligned to 8 bytes",
+	 * or, "the specified input or output parameter lists spans pages".
+	 */
 	aligned_msg = (struct hv_input_post_message *)
 			(ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
 
+	alighed_msg_start = (unsigned long)aligned_msg;
+	alighed_msg_end = (unsigned long)&aligned_msg->payload +
+			  payload_size - 1;
+
+	if ((alighed_msg_start >> PAGE_SHIFT) !=
+	    (alighed_msg_end >> PAGE_SHIFT)) {
+		aligned_msg = (struct hv_input_post_message *)
+				__get_free_page(GFP_ATOMIC);
+		if (!aligned_msg) {
+			status = -ENOMEM;
+			goto out;
+		}
+		need_free_aligned_msg = true;
+	}
+
 	aligned_msg->connectionid = connection_id;
 	aligned_msg->message_type = message_type;
 	aligned_msg->payload_size = payload_size;
@@ -244,6 +268,11 @@ int hv_post_message(union hv_connection_id connection_id,
 	status = do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
 		& 0xFFFF;
 
+	WARN(status == HV_STATUS_INVALID_ALIGNMENT,
+		"status = %d\n", status);
+	if (need_free_aligned_msg)
+		free_page((unsigned long)aligned_msg);
+out:
 	kfree((void *)addr);
 
 	return status;

