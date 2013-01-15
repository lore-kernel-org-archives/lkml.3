Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab3AOPLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:11:46 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:35091 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab3AOPLp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:11:45 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:11:31 +0100
Subject: RE: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Topic: [RFCv2 07/11] remoteproc: Register virtio devices after vring
 allocation
Thread-Index: Ac3fIWtLiUfJJSxzThuEewR8D0BAWgUDTdrw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE060@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021801.GD28692@WorkStation.localnet>
In-Reply-To: <20121221021801.GD28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

> On Fri, Dec 14, 2012 at 05:06:56PM +0100, Sjur Brændeland wrote:
> > Postpone the registration of virtio devices until all
> > vritio ring resource has been allocated.
> > This fixes the following bug: The driver's start callback
> > is called before all vring notify ids are allocated and
> > max_notifyid will be increased after starting the remoteproc.
> 
> It seems that this patch wont solve this issue, since
> rproc_add_virtio_dev eventually increases max_notifyid, so the same
> problem will simply occur at a later stage.
> 
> Also, it seems that the original rproc_add_virtio_dev calls were not
> removed, so devices would be added twice.
> 
> If max_notifyid needs to be set before the first virtio device is added,
> how about counting the number of notification ids in advance before
> adding the devices, by traversing the resource list twice?

OK, I'll just simply count the number of vrings registered then.

Regards,
Sjur
