Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbbAFQPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:15:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48248 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbbAFQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:15:12 -0500
Message-ID: <54AC0A09.5020008@gmail.com>
Date: Wed, 07 Jan 2015 00:15:05 +0800
From: =?UTF-8?B?QWRyaWFuIFPDoW5kb3I=?= <aditsu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: RTS5129 card reader fails to read SDXC card using the new kernel
 drivers
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have a Lenovo Yoga 13 laptop with a Realtek RTS5129 card reader 
(0bda:0129)
It used to work fine with the RTS5139 kernel driver, but apparently that 
driver was removed since kernel 3.16 and replaced with MFD_RTSX_USB / 
MMC_REALTEK_USB.
I upgraded to kernel 3.18.1 and compiled those drivers, and now I'm 
getting this kind of errors when I insert my SDXC card:

Jan  6 22:59:44 yoga kernel: [  812.978737] mmc0: error -22 whilst 
initialising SD card
Jan  6 22:59:45 yoga kernel: [  813.981192] mmc0: error -22 whilst 
initialising SD card
Jan  6 22:59:46 yoga kernel: [  815.053945] mmc0: new ultra high speed 
SDR50 SDXC card at address 1234
Jan  6 22:59:46 yoga kernel: [  815.054086] mmcblk0: mmc0:1234 SA64G 
57.7 GiB
Jan  6 22:59:46 yoga kernel: [  815.056112]  mmcblk0: unknown partition 
table
Jan  6 22:59:47 yoga kernel: [  815.662453] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:48 yoga kernel: [  816.265726] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:48 yoga kernel: [  816.872253] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x80800b00
Jan  6 22:59:49 yoga kernel: [  817.475467] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:49 yoga kernel: [  818.079672] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:50 yoga kernel: [  818.681950] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:51 yoga kernel: [  819.286227] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
Jan  6 22:59:52 yoga kernel: [  820.494652] mmcblk0: error -110 sending 
status command, retrying
Jan  6 22:59:52 yoga kernel: [  820.495144] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0xb00
Jan  6 22:59:52 yoga kernel: [  821.100047] mmcblk0: error -110 sending 
stop command, original cmd response 0x900, card status 0x900
(etc)

Sometimes I'm just getting the "error -22" messages.
The card is a Toshiba 64GB SDXC class 10, UHS 1. It works fine with an 
external USB card reader.
Also, I tried another card, a Transcend 16GB SDHC class 10, and it works 
fine in the laptop's card reader.

Please help investigate this problem and let me know if I should do 
something on my side.

Thanks
Adrian
