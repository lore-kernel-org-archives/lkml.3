Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3III00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:26:26 -0400
Received: from postout2.mail.lrz.de ([129.187.255.138]:35243 "EHLO
	postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3III0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:26:24 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 04:26:24 EDT
From: "Morales, Alejandra" <alejandra.morales@tum.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Doubts on IO requests in USB subsystem
Thread-Topic: Doubts on IO requests in USB subsystem
Thread-Index: Ac6tNIxdeqg8/IyVTFGPG7NXqAfNbw==
Date: Mon, 9 Sep 2013 08:20:06 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>
Accept-Language: es-ES, en-US
Content-Language: es-ES
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4ca0:2001:40:180c:9e10:7674:37e7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

For my master thesis I am developing a user space power management tool. For that purpose
I am implementing a kernel module and one task this module does is to intercept calls to the
request_fn function for every scsi device in order to check when they are actually being requested
an IO operation.

I am testing with a regular SATA hard drive and with an external USB hard drive. Both are just
mounted and there is no application using them at the moment, so that I was expecting that none
of them receive file system requests. Indeed the SATA HD does not receive any requests unless I
mount or unmount it, but the USB HD receives a large number of file system requests and it seems
that it never enters into an idle state. Since any application is using it I think these requests may
come from the USB subsystem. Am I right? If so, how could I determine whether a request comes
from the USB subsystem or it is a file system request that actually moves blocks?

Thanks in advance.
Regards,
Alejandra