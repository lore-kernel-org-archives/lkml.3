Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaETGKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:10:07 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:52354
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbaETGKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:10:05 -0400
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/6] input: cyapa: rearchitecture driver to support
 function pointers
Thread-Topic: [PATCH 1/6] input: cyapa: rearchitecture driver to support
 function pointers
Thread-Index: Ac9Xtq9L7NojvOgjROesZ4GoflAFFABl+2KwBqxKswAAA5snQA==
Date: Tue, 20 May 2014 06:10:01 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C32648@S04-MBX01-01.s04.local>
References: <77BC725C9062764F874D79F51E1F1A8F40C1405E@S04-MBX01-01.s04.local>
 <20140520034742.GC986@core.coreip.homeip.net>
In-Reply-To: <20140520034742.GC986@core.coreip.homeip.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.154]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for your advice, I will organize it and resubmit it as v2.

Thanks,
Dudley

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, May 20, 2014 11:48 AM
> To: Dudley Du
> Cc: Benson Leung; Daniel Kurtz; David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/6] input: cyapa: rearchitecture driver to support function pointers
>
> Hi Dudley,
>
> On Wed, Apr 16, 2014 at 08:35:52AM +0000, Dudley Du wrote:
> > Re-architecture the driver to support function pointers, so it can support and integrate new devices later in one driver.
> > Including use async thread in device proble to speed up system boot time.
> > TEST=test on Chomebooks.
>
> There seems to be changes implementing aasync probing intermixed with the function pointers change, it had to be split out and justification needs to be provided - I am not quite convinced we should be doing this, at least not at individual driver level.
>
> Also instead of listing individual function pointers consider defining
>
> struct cyapa_ops {
>       void (*irq_handler)(struct cyapa *);
>       int (*set_power_mode)(struct cyapa *, u8, u16);
>       int (*bl_enter_func)(struct cyapa *);
>       ....
> };
>
> and use const pointer to it in cyapa_state. Then you can have gen3 and
> gen5 implementation separated into individual files and the rest forming cyapa core.
>
> Thanks.
>
> --
> Dmitry
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
