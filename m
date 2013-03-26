Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3CZTuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:50:12 -0400
Received: from smtp-out-013.synserver.de ([212.40.185.13]:1262 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752251Ab3CZTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:50:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26673
Message-ID: <5151FC65.80409@metafoo.de>
Date: Tue, 26 Mar 2013 20:52:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: bq27x00_battery: Export all battery registers
 via sysfs
References: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com> <50FBBE7D.7040102@metafoo.de> <201303262027.39772@pali>
In-Reply-To: <201303262027.39772@pali>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 08:27 PM, Pali Rohár wrote:
> On Sunday 20 January 2013 10:53:01 Lars-Peter Clausen wrote:
>> On 01/19/2013 03:01 PM, Pali Rohár wrote:
>>> bq27xxx batteries have a lot of properties, more than
>>> power_supply interface. Some of them can be usefull for
>>> userspace applications (like CI bit) but does not make
>>> sense to add bq specified property to power_supply
>>> interface. When bq27x00_battery is not loaded userspace
>>> application (like i2cget) can use /dev/i2c-* interface for
>>> raw access. But when kernel module is attached to i2c
>>> device, userspace applications cannot access it via
>>> /dev/i2c-*.
>>
>> You can still access it if you use the I2C_SLAVE_FORCE flag.
>> This is a bit ugly, but I'd rather see an ugly hack in
>> userspace than in kernel space.
>>
> 
> What is I2C_SLAVE_FORCE flag doing? Isnt there some potential 
> hardware damage problems (like simultaneous access to i2c bus)?
> 

Well the transfers will still be serialized. I don't think this will cause
damage to the hardware.

- lars
