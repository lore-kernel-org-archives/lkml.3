Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaAZKxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:53:10 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:39273 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:53:08 -0500
Message-ID: <52E4E913.6030300@roeck-us.net>
Date: Sun, 26 Jan 2014 02:53:07 -0800
From: Guenter Roeck <groeck7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Using an optional regulator in a driver running on a PC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am currently writing a driver which uses an optional regulator
to determine a reference voltage. The regulator is truly optional;
if it is not there, the chip uses an internal reference voltage.

I am testing the driver on a PC which does not really have any
regulators installed or enabled. Kernel version is 3.13.

I noticed that the call to regulator_get() returns -EPROBE_DEFER.
Looking into the regulator core, this appears intentional; there is
obviously no devicetree entry, and there is no regulator device.
The regulator code always returns -EPROBE_DEFER in this case.
I also tried regulator_get_optional(), with the same results.

This leads to an interesting question: How are drivers which require
regulators (optional or not) supposed to run on a system
which does not support devicetree, and does not have any
regulators installed (such as a PC) ? REGULATOR_DUMMY
isn't there anymore, and the dummy code it replaces only
executes on devicetree based systems.

Also, how are non-dt systems supposed to determine if an optional
regulator exists or not ? AFAICS the regulator code always returns
-EPROBE_DEFER, which isn't very helpful. If I just assume that
-EPROBE_DEFER means that the regulator is not there, I end up with
a conflict with a system which _does_ support devicetree, where
-EPROBE_DEFER really means that the probe needs to be deferred.

Thanks,
Guenter

