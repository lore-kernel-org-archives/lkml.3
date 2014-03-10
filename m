Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaCJKZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:25:00 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:56561 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbaCJKY5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:24:57 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -4.4
X-Spam-Languages: en
Message-ID: <531D92F7.7080509@topic.nl>
Date: Mon, 10 Mar 2014 11:24:55 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl> <20140309202107.GA2835@katana>
In-Reply-To: <20140309202107.GA2835@katana>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 03/09/2014 09:21 PM, Wolfram Sang wrote:
> On Thu, Jan 09, 2014 at 12:11:25PM +0100, Mike Looijmans wrote:
>> When a signal is caught while the i2c-davinci bus driver is transferring,
>> the drive just "abandons" the transfer and leaves the controller to fend
>> for itself. The next I2C transaction will find the controller in an
>> undefined state and often results in a stream of "initiating i2c bus recovery"
>> messages until the controller arrives in a defined state. This behaviour
>> also sends out "half" or possibly even mixed messages to I2C client
>> devices which may put them in an undesired state as well.
>>
>> This patch fixes this issue by always attempting to finish the current
>> transaction, and then check on a pending signal. It either reports
>> success if all data has been transferred, or it returns failure when
>> the transaction was aborted. This keeps the controller in a defined
>> state, and is also much friendlier towards client devices, because
>> it will only send complete messages.
>
> Even more, you should complete the whole transfer. There are devices
> where things can really go wrong if you send a half-complete command and
> then start with the next one. So, not checking signals at all is the way
> to go for I2C drivers. There is some cruft left, so I am happy about
> patches fixing that, with testing on real HW. Like yours here.

I agree.

I know the Zynq (using a cadence controller) also lets signals interrupt I2C 
transfers, so I'll propose a patch to Xilinx and CC to you and linux-i2c to 
completely remove signal handling from that driver as well.

Mike


Met vriendelijke groet / kind regards,

Mike Looijmans

TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

