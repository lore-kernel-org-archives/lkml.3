Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaEPFgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 01:36:10 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38173 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaEPFgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 01:36:08 -0400
Message-ID: <5375A3B5.1060706@ahsoftware.de>
Date: Fri, 16 May 2014 07:35:49 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: [PATCH 2/2] bluetooth: raise HCI_CMD_TIMEOUT from 2s to 8s
References: <1400076025-5103-1-git-send-email-holler@ahsoftware.de>	<1400076025-5103-2-git-send-email-holler@ahsoftware.de> <CABBYNZLFutVy=Msz7=AAwXmo4wDHjv59GcLCedEzSrWjkLQ3cw@mail.gmail.com> <5374D452.8020709@ahsoftware.de> <5374DAEF.40605@ahsoftware.de>
In-Reply-To: <5374DAEF.40605@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.05.2014 17:19, schrieb Alexander Holler:
> Am 15.05.2014 16:50, schrieb Alexander Holler:
>> Am 15.05.2014 14:54, schrieb Luiz Augusto von Dentz:
>
>>> This timeout seems arbitrary so I suppose we can increase it if we
>>> feel it is necessary but we used already different timeout for
>>> different commands like HCI_POWER_OFF_TIMEOUT, so perhaps if we can
>>> identify which command is more likely to timeout.
>>>
>>> We could perhaps auto reset if a command timeout if there is really no
>>> other way to recover.
>>
>> It is arbitrary but 2s is not enough here. And as I've written in the
>> description, there is absolutely no reason to keep this timeout
>> unnecessarily short. No one cares if an error message appears after 2s
>> or 8s if the communication with the dongle is in both cases broken
>> afterwards.
>>
>> One of the commands I experieced the problem with was e.g.
>> HCI_OP_DELETE_STORED_LINK_KEY or HCI_OP_WRITE_SSP_MODE.
>
> The problem is that you can never be sure what the origin of a timeouted
> command was. It might have been e.g. the USB-subsystem through wich the
> command and the response has to travel (in case of USB dongles) and not
> the dongle itself.

To explain a bit more, the box I'm experiencing these problems boots 
from USB2.0 HD. So it's likely that there is quiet some action on the 
bus and that shouldn't affect the operation of the BT-stack (besides 
slowing it maybe a bit down).

Regards,

Alexander Holler

