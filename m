Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3LVAnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 19:43:11 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:44456 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754940Ab3LVAnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 19:43:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131220042426.GA21726@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
	<1387507503-7565-3-git-send-email-rapatel@apm.com>
	<20131220032133.GB32310@kroah.com>
	<CAN1v_PuBZHN85xTodfSZ-+H4Wdj0T8kSFUJB56KVj9xFH3--JQ@mail.gmail.com>
	<20131220042426.GA21726@kroah.com>
Date: Sat, 21 Dec 2013 16:43:06 -0800
Message-ID: <CAN1v_Pv-RRTW7cr5xNgAMySQrZi9zMxNjJfnKPi8fa3GUhGpNg@mail.gmail.com>
Subject: Re: [PATCH 2/4] misc: xgene: Add base driver for APM X-Gene SoC Queue
 Manager/Traffic Manager
From: Ravi Patel <rapatel@apm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
        "patches@apm.com" <patches@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Dec 19, 2013 at 07:41:13PM -0800, Ravi Patel wrote:
>> There is no need to talk to this driver from userspace.
>> It is a device which is used by other IO devices to communicate with each
>> other, including CPU.
>> For example, if CPU (software) wants to send a message to Ethernet HW (i.e.
>> send packet),
>> it used this driver to enqueue a message to Ethernet.
>> In other direction, if Ethernet HW receives a packet, it uses QM/TM device to
>> send message to
>> CPU (software) to process packet.
>
> So it's a "bus" type of thing, right?
>
> My question of "why isn't this reflected in the driver model" still
> stands.

There is no subsystem underneath QMTM, nor QMTM does any enumeration.
QMTM is a centralized resource manager which manages queues circularly
for Ethernet, PktDMA (XOR Engine) and Security Engine subsystems.
Traffic Management feature of QMTM does flow control, QoS for the subsystems.
Because of this reasons, its not obvious that QMTM can fit as a bus.
However we are doing further evalution on this.

Thanks,
Ravi
