Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3KITmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 14:42:35 -0500
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:59874
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3KITmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 14:42:32 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: add support for GMT G751 chip in lm75 driver
References: <87bo1th3ul.fsf@natisbad.org>
	<20131109182707.GA19407@roeck-us.net>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131109:pawel.moll@arm.com::G9nVYfUqBSrIfC6C:000000000000000000000000000000000000000000007Or
X-Hashcash: 1:20:131109:linux@roeck-us.net::ZFdCRrHuc8dAQQk7:00000000000000000000000000000000000000000000pqI
X-Hashcash: 1:20:131109:ijc+devicetree@hellion.org.uk::dFY7+Rq0TC5f5laU:000000000000000000000000000000001BLI
X-Hashcash: 1:20:131109:rob.herring@calxeda.com::VecOPH+iKSi9EP0A:000000000000000000000000000000000000001geu
X-Hashcash: 1:20:131109:linus.walleij@linaro.org::1MGb9L5v406RLURh:000000000000000000000000000000000000028Eg
X-Hashcash: 1:20:131109:arnd@arndb.de::w1w0ZVGHFuQN8EBk:00002Xdx
X-Hashcash: 1:20:131109:khali@linux-fr.org::RAlmeF9WJaF1FYIH:00000000000000000000000000000000000000000002Kbm
X-Hashcash: 1:20:131109:lm-sensors@lm-sensors.org::RUsqH3FvkGQRyIP6:0000000000000000000000000000000000003UCx
X-Hashcash: 1:20:131109:grant.likely@linaro.org::qtO6JHRm1jz8wArK:00000000000000000000000000000000000000433Q
X-Hashcash: 1:20:131109:mark.rutland@arm.com::oa92iORNiXsYLsUS:000000000000000000000000000000000000000003Rdx
X-Hashcash: 1:20:131109:rob@landley.net::b1uhs2NMO9RjcD/p:005Cv7
X-Hashcash: 1:20:131109:linux-kernel@vger.kernel.org::bnkCrkwyPYD/9Xc6:0000000000000000000000000000000005QoO
X-Hashcash: 1:20:131109:devicetree@vger.kernel.org::ifVhbxtx2x0HIpWf:000000000000000000000000000000000008Py5
X-Hashcash: 1:20:131109:linux-doc@vger.kernel.org::poh6M/onRR29gLQs:0000000000000000000000000000000000006kqt
X-Hashcash: 1:20:131109:swarren@wwwdotorg.org::s748vyrihQMTnFCS:0000000000000000000000000000000000000000A42S
Date: Sat, 09 Nov 2013 20:42:05 +0100
Message-ID: <87txflfjle.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Guenter Roeck <linux@roeck-us.net> writes:

> On Sat, Nov 09, 2013 at 06:39:14PM +0100, Arnaud Ebalard wrote:
>> 
>> This was tested on a NETGEAR ReadyNAS 2120 device (Marvell Armada XP
>> based board, via DT).
>> 
>> Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
>
> Looks good. I'll apply it to my -next branch. Since I already sent my 
> pull request to Linus, this will only go in after -rc1, which I hope
> should be ok (unless Jean wants to pick it up for his pull request).

Perfect, thanks.


>> ---
>> Hi Guenter,
>> 
>> As a side note, I removed the hunk that was present in previous patch to
>> add gmt to the list of DT vendor prefixes because I noticed someone had
>> taken care: https://lkml.org/lkml/2013/9/12/365
>> 
>> For the records, here is what I get on my NAS with the attached patch:
>> 
>> root@thin:/sys# sensors
>> g762-i2c-0-3e
>> Adapter: mv64xxx_i2c adapter
>> fan1:        5461 RPM  (div = 1)
>> 
>> g762-i2c-0-48
>> Adapter: mv64xxx_i2c adapter
>> fan1:        5461 RPM  (div = 1)
>> 
>> g762-i2c-0-49
>> Adapter: mv64xxx_i2c adapter
>> fan1:        5461 RPM  (div = 1)
>> 
> Those rpms are pretty high. Are the fans all really running that fast ?

Unlike the fans on NETGEAR ReadyNAS 102 and 104 which are Protechnic
MGT9212YB-025 92mmx92mm running at 3200 RPM max, the three fans in the
RN2120 are Protechnic MGT4012XB-O20, i.e. 40mmx40mm running at 8000 RPM
max. At least, this is the max RPM value I found on their website
(Search Products on left side of http://www.protechnic-us.com/en/) for
both devices.

When pushing one a bit, here is the max rotation speed I get:

 root@thin:/sys/bus/i2c/drivers/g762/0-003e# echo 9000 > fan1_target ; \
                                             sleep 5 ; cat fan1_input
 8057

which AFAICT validates current settings for G762 and fan combination.
Did I miss something?

Cheers,

a+
