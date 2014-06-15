Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaFOVcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:32:15 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:55455 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaFOVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:32:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1402864790-7478-1-git-send-email-jm@lentin.co.uk>
References: <1402864790-7478-1-git-send-email-jm@lentin.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v3 0/2] Add support for Lenovo Compact Keyboard
From: Alexander Clouter <alex@digriz.org.uk>
Date: Sun, 15 Jun 2014 22:32:06 +0100
To: Jamie Lentin <jm@lentin.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        Antonio Ospite <ao2@ao2.it>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <b2a949a6-cd86-437c-a746-d71394f228d6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Alexander Clouter <alex@digriz.org.uk>

On 15 June 2014 21:39:48 GMT+01:00, Jamie Lentin <jm@lentin.co.uk> wrote:
>This patchset follows on from my previous attempts to add support for
>these keyboards from Lenovo.
>
>Changes since v2: https://lkml.org/lkml/2014/6/10/730
>* Rename hid-lenovo-tpkbd to hid-lenovo, to make it obvious this is
>  for any Lenovo-manufactured device [Antonio Ospite, Jiri Kosina]
>* Style fixes: function calls in conditions, combine checks for 
>  both USB & BT keyboards [Antonio Ospite]
>
>Changes since v1: https://lkml.org/lkml/2014/3/25/535
>* Merge driver into hid-lenovo-tpkbd.c instead of creating our own
>  driver for the hardware [Jiri Kosina]
>* Remove key mappings which are now supported by standard
>* Use KEY_FILE for Fn-F12 (opens My Computer on Windows)
>* Support the USB variant as well as Bluetooth
>* Expose the Fn Lock setting as a sysfs attribute instead of trying to
>  build a mechanism to toggle into the kernel
>
>Applies against 3.14.5, tested with Bluetooth and USB variants of the
>Compact Keyboard with Trackpoint, as well as the original Thinkpad USB
>keyboard (thanks to Alexander Clouter).
>
>Cheers,
>
>Jamie Lentin (2):
>  Rename hid-lenovo-tpkbd to hid-lenovo, so we can add other keyboards
>  Add support for Compact (Bluetooth|USB) keyboard with Trackpoint
>
> drivers/hid/Kconfig            |  16 +-
> drivers/hid/Makefile           |   2 +-
> drivers/hid/hid-core.c         |   2 +
> drivers/hid/hid-ids.h          |   2 +
> drivers/hid/hid-lenovo-tpkbd.c | 462 ---------------------------
>drivers/hid/hid-lenovo.c       | 697
>+++++++++++++++++++++++++++++++++++++++++
> include/linux/hid.h            |   1 +
> 7 files changed, 712 insertions(+), 470 deletions(-)
> delete mode 100644 drivers/hid/hid-lenovo-tpkbd.c
> create mode 100644 drivers/hid/hid-lenovo.c

-- 
Alexander Clouter
