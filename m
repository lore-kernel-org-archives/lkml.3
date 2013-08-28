Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3H1GHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:07:43 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44060 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3H1GHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130828012752.GD10506@lizard>
References: <1377125110-16886-1-git-send-email-marek.belisko@open-nandra.com>
	<20130828012752.GD10506@lizard>
Date: Wed, 28 Aug 2013 08:07:41 +0200
Message-ID: <CAAfyv34Y69L3HLG9GB43JE7_EWWg143BD3jcq8xfmFUraD1JGA@mail.gmail.com>
Subject: Re: [PATCH] power: rx51_battery: Replace hardcoded channels values.
From: Belisko Marek <marek.belisko@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        pali.rohar@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Wed, Aug 28, 2013 at 3:27 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Thu, Aug 22, 2013 at 12:45:10AM +0200, Marek Belisko wrote:
>> In twl4030_madc header exist defines for fixed channels
>> + add rx51 specific channels and replace all hardcoded channels
>> values.
>>
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>
> Applied, thanks!
Thanks for that. Unfortunately yesterday I was working on similar code
and found issue (wrong channel index) which was introduced by this
commit.
Fix is below. Sorry for troubles.

From: Marek Belisko <marek.belisko@open-nandra.com>
Date: Wed, 28 Aug 2013 08:04:10 +0200
Subject: [PATCH] power: rx51_battery: Fix channel number when reading adc
 value.

This issue was introduced in commit:
power: rx51_battery: Replace hardcoded channels values.

Original code use channel as argument which was shifted by one in function.
After mentioned commit argument is already shifted so we need to get index
back.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/power/rx51_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 03f5761..1bc5857 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -51,7 +51,7 @@ static int rx51_battery_read_adc(int channel)
  if (twl4030_madc_conversion(&req) <= 0)
  return -ENODATA;

- return req.rbuf[channel];
+ return req.rbuf[ffs(channel) - 1];
 }

 /*
-- 
1.7.9.5

>
> Anton

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
