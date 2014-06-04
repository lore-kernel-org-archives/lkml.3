Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaFDDQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 23:16:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:38732 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaFDDQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 23:16:31 -0400
Message-ID: <538E8F70.2010600@windriver.com>
Date: Wed, 4 Jun 2014 11:16:00 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org> <538E745B.1020200@windriver.com> <411dd8052ca74ed38810f2a5248063e2@BL2PR03MB226.namprd03.prod.outlook.com>
In-Reply-To: <411dd8052ca74ed38810f2a5248063e2@BL2PR03MB226.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 09:45 AM, Peter Chen wrote:
>   
>> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
>> Author: Robert Baldyga <r.baldyga@samsung.com>
>> Date:   Thu Nov 21 13:49:18 2013 +0100
>>
>>       usb: gadget: s3c-hsotg: fix disconnect handling
>>
>>       This patch moves s3c_hsotg_disconnect function call from USBSusp
>> interrupt
>>       handler to SET_ADDRESS request handler.
>>
> It is a little strange we call gadget's disconnect at SET_ADDRESS?
> How the udc calls gadget driver the disconnection has happened when
> the usb cable is disconnected from the host?
>
> Usually, we call gadget's disconnect at two situations
>
> - udc's reset handler if udc's speed is not UNKNOWN, it is usually happened
> when the host sends reset after enumeration.
> - udc's disconnect handler, it is usually happened when the usb cable
> is disconnected from host.

Hmm, usually the two situations, but according to the commit log, s3c 
hsotg does not support Disconnected interrupt for device mode,
so the second situation does not happen for s3c hsotg, therefore, he has 
to disconnect the connection before it is connected again.

Wei
>
> Peter
>
>

