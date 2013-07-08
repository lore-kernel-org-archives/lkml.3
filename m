Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3GHSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:50:54 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:36828 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3GHSux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:50:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] btusb: fix overflow return values
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1372941783-30657-1-git-send-email-adam.lee@canonical.com>
Date: Mon, 8 Jul 2013 11:50:54 -0700
Cc: linux-bluetooth@vger.kernel.org,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        "Anthony Wong'" <anthony.wong@canonical.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Content-Transfer-Encoding: 8BIT
Message-Id: <25CD2206-7B7B-4DAD-A714-A79976C9DB13@holtmann.org>
References: <1372941783-30657-1-git-send-email-adam.lee@canonical.com>
To: Adam Lee <adam.lee@canonical.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

> PTR_ERR() returns a long type value, but btusb_setup_intel() and
> btusb_setup_intel_patching() should return an int type value.
> 
> This bug makes the judgement "if (ret < 0)" not working on x86_64
> architecture systems, leading to failure as below, even panic.
> 
> [   12.958920] Bluetooth: hci0 command 0xfc8e tx timeout
> [   14.961765] Bluetooth: hci0 command 0xfc8e tx timeout
> [   16.964688] Bluetooth: hci0 command 0xfc8e tx timeout
> [   20.954501] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   22.957358] Bluetooth: hci0 command 0xfc8e tx timeout
> [   30.948922] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   32.951780] Bluetooth: hci0 command 0xfc8e tx timeout
> [   40.943359] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   42.946219] Bluetooth: hci0 command 0xfc8e tx timeout
> [   50.937812] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   52.940670] Bluetooth: hci0 command 0xfc8e tx timeout
> [   60.932236] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   62.935092] Bluetooth: hci0 command 0xfc8e tx timeout
> [   70.926688] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   72.929545] Bluetooth: hci0 command 0xfc8e tx timeout
> [   80.921111] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
> [   82.923969] Bluetooth: hci0 command 0xfc2f tx timeout
> [   90.915542] Bluetooth: hci0 sending Intel patch command (0xfc2f) failed (-110)
> [   92.918406] Bluetooth: hci0 command 0xfc11 tx timeout
> [  100.909955] Bluetooth: hci0 sending Intel patch command (0xfc11) failed (-110)
> [  102.912858] Bluetooth: hci0 command 0xfc60 tx timeout
> [  110.904394] Bluetooth: hci0 sending Intel patch command (0xfc60) failed (-110)
> [  112.907293] Bluetooth: hci0 command 0xfc11 tx timeout
> [  120.898831] Bluetooth: hci0 exiting Intel manufacturer mode failed (-110)
> [  120.904757] bluetoothd[1030]: segfault at 4 ip 00007f8b2eb55236 sp 00007fff53ff6920 error 4 in bluetoothd[7f8b2eaff000+cb000]
> 
> For not affecting other modules, I choose to modify the return values
> but not extend btusb_setup_intel() and btusb_setup_intel_patching()'s
> return types. This is harmless, because the return values were only
> used to comparing number 0.

there are tons of examples in various subsystems and drivers where we return PTR_ERR from a function calls returning int.

So I wonder what is actually going wrong here. If this is x86_64 specific problem with PTR_ERR vs int, then we should have this problem everywhere in the kernel.

Regards

Marcel

