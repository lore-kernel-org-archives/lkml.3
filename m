Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3HVLBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:01:12 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48270 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3HVLBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:01:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMQbqHRkF4_gK=GA587LDghkYtd1hRQhLObV+Tbe9zEDbS5-Q@mail.gmail.com>
References: <CAOMQbqHRkF4_gK=GA587LDghkYtd1hRQhLObV+Tbe9zEDbS5-Q@mail.gmail.com>
From: Stan G <stangoesagain@gmail.com>
Date: Thu, 22 Aug 2013 18:00:48 +0700
Message-ID: <CAOMQbqEZKytz42CcjXwBiyiKotU0Wh1_9_TX2NP+qSjpP71+og@mail.gmail.com>
Subject: Fwd: ipw2200: Fix race condition in the command completion acknowledge
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Stan G <stangoesagain@gmail.com>
Date: Wed, Aug 21, 2013 at 3:16 PM
Subject: ipw2200: Fix race condition in the command completion acknowledge
To: stas.yakovlev@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org


Hi,

This is regarding kernel patch history:

>>>>

commit dd447319895d0c0af423e483d9b63f84f3f8869a
Author: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date: Thu Apr 19 15:55:09 2012 -0400
ipw2200: Fix race condition in the command completion acknowledge

Driver incorrectly validates command completion: instead of waiting
for a command to be acknowledged it continues execution. Most of the
time driver gets acknowledge of the command completion in a tasklet
before it executes the next one. But sometimes it sends the next
command before it gets acknowledge for the previous one. In such a
case one of the following error messages appear in the log:

Failed to send SYSTEM_CONFIG: Already sending a command.
Failed to send ASSOCIATE: Already sending a command.
Failed to send TX_POWER: Already sending a command.

After that you need to reload the driver to get it working again.

This bug occurs during roaming (reported by Sam Varshavchik)
https://bugzilla.redhat.com/show_bug.cgi?id=738508
and machine booting (reported by Tom Gundersen and Mads Kiilerich)
https://bugs.archlinux.org/task/28097
https://bugzilla.redhat.com/show_bug.cgi?id=802106

This patch doesn't fix the delay issue during firmware load.
But at least device now works as usual after boot.

Cc: stable@kernel.org
Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

>>>>

I am having intermittent problems with dropping wifi network while the
 AP is still visible and dmesg produces this:

      [26617.864791] ipw2200: Failed to send ASSOCIATE: Already
sending a command.


I'm on OpenSuse 12.3 with 3.7.10-1.16

The whole story of this problem can be viewed here:

https://forums.opensuse.org/english/get-technical-help-here/network-internet/489371-wifi-up-access-point-visible-but-network-goes-down.html

where at the end I was advised to contact you, guys.

Reloading driver restores network as expected.

Can anything be done regarding this issue or is the driver too old to be fixed?

Would updating to the latest kernel solve the problem?

Stan
