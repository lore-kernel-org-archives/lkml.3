Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHIO1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:27:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaHIO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:27:50 -0400
Message-ID: <53E62EEF.9040801@gmail.com>
Date: Sat, 09 Aug 2014 17:23:43 +0300
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
CC: Yinghai Lu <yinghai@kernel.org>
Subject: Loading initrd above 4G causes freeze on boot
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
the kernel freezes at the earliest possible moment when trying to boot
via UEFI on my Asus laptop. (It still boots via BIOS.)

If I revert that commit on current master (c309bfa9b481), it boots
correctly again [although I see "setup_efi_pci() failed" being printed].

(Seems like it freezes when handle_cmdline_files() attempts to read
the last chunk of the initramfs -- the last call to efi_file_read()
never returns. Figuring out why that happens is beyond me, though.)

-- 
Mantas Mikulėnas <grawity@gmail.com>
