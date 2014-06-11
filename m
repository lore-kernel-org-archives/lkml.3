Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaFKDkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:40:01 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:12120
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755252AbaFKDj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:39:59 -0400
Date: Wed, 11 Jun 2014 10:14:40 +0800
From: Peter Chen <peter.chen@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611021439.GA25082@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(21056001)(47776003)(92726001)(102836001)(4396001)(83322001)(20776003)(46406003)(23726002)(50986999)(76482001)(54356999)(44976005)(64706001)(99396002)(6806004)(77096999)(92566001)(46102001)(74662001)(83506001)(77982001)(81542001)(80022001)(97756001)(97736001)(31966008)(26826002)(79102001)(84676001)(86362001)(81342001)(87936001)(69596002)(68736004)(104016001)(50466002)(81156002)(74502001)(85852003)(33656002)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0636;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0239D46DB6
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Currently, we can't disable auto probe function during booting
if both device and device driver register code are built in due
to .drivers_autoprobe is a private value for bus core and this
value can only be changed by sys entry.

It causes we can't implement feature that the user can choose
manual binding and auto binding through module parameters.
Eg, the default binding is automatic, but the user can override
it by module parameter.

Let's take USB peripheral as an example, there is a device for
udc, and a device driver for usb gadget driver, at default, we want
the device to be bound to driver automatically, this is what
we have done now. But if there are more than one udcs and gadget
drivers (eg one B port for mass storage, another B port for usb ethernet),
the user may want to have specific binding (eg, udc-0 -> mass storage,
udc-1 -> usb ethernet), so the binding will be established
after rootfs has mounted. (This feature is implementing)

>From what I read code, we can't implement above feature, but I may
be wrong, if you have some solutions, give me some hints please.
If there is no solution for above feature, do we agree with exporting
.drivers_autoprobe for bus driver or something similar?

-- 

Best Regards,
Peter Chen
