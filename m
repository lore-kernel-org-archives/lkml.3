Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3GYGAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:00:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27738 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GYGA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:00:27 -0400
X-AuditID: cbfee6a3-b7fe56d0000075aa-cd-51f0bef9cf11
Date: Thu, 25 Jul 2013 06:00:25 +0000 (GMT)
From: Tarak Anumolu <tarak.anumolu@samsung.com>
Subject: Need help in using udev
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Reply-to: tarak.anumolu@samsung.com
MIME-version: 1.0
X-MTR: 20130725055835052@tarak.anumolu
Msgkey: 20130725055835052@tarak.anumolu
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130725054032684@tarak.anumolu
X-ParentMTR: 20130725054032684@tarak.anumolu
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <10322723.303681374732025069.JavaMail.weblogic@epml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/t6bo/930INFh1QMvi8q45bA6MHp83
	yQUwRnHZpKTmZJalFunbJXBlTL74n6mgTaDi/PwG5gbGM/xdjJwcQgIaEo9PPmbqYuTgkBAw
	kbg8JQ4kLCEgJnHh3nq2LkYuoJL5jBLtt+YzgiRYBFQlbn3ezQpiswkYSFyctJQNxBYWUJDo
	7H4FFhcR8JC4t+INE8R8ZYk/E3vBangFBCVOznzCArFLTeL6Aj2IsLpE/+ZWZoi9chJLpl5m
	grB5JWa0P2WBiU/7ugaqRlri/KwNjDB3Lv7+GCrOL3Hs9g6oV3glntwPhhmze/MXNghbQGLq
	mYNQrdoSH949glqlK7Fz9mq4MbtOLWeG6b2/ZS5YDbOAosSU7ofsELaBxJFFc1hRfQViO0ns
	/buEdQKj7CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqFsV5xYm5xaV66XnJ+7iZGcCw/W7yD
	8f9560OMAhyMSjy8AV/fBwqxJpYVV+YeYpTgYFYS4Y2t+BAoxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnPdZq3WgkEB6YklqdmpqQWoRTJaJg1OqgTHxp7iSzGZBPdddC6x/FrKtyjsb4ZPQ0ewY
	fWDvFZPZ6dMttNavubtbkvH2jF9/l77yPq5f25Qjqpudc1Fi/reX14xfcbHXaaS5bLtfEKLN
	dVbrLP/2j9NDHWTm9a76ZiJ/+bJNYEAJ1yTNcubb8g4XVS+nds01Pl3qelFO/uX3ioa4+b1/
	WJRYijMSDbWYi4oTAfybfoDhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6P60ZVp001612


Hi

My name is Tarak, working in Samsung-SouthKorea.

I got some problem in using udev, particulary in writing rules for network interfaces.

Following is the rule for my udev.

Every thing is working fine except the network interface.

My aim is to run network.sh script when the interface got connected/ disconnected.

Can anyone help me on this.


# Media automounting
SUBSYSTEM=="block", ACTION=="add"    RUN+="/etc/udev/scripts/mount.sh"
SUBSYSTEM=="block", ACTION=="remove" RUN+="/etc/udev/scripts/mount.sh"
# Added HDD/USB Storage Hotplug by BSP Team at 2013/2/18
KERNEL=="sd[a-z]", RUN+="/root/usb_hotplug.sh"
KERNEL=="mouse0", RUN+="/root/mouse_hotplug.sh"
# Handle network interface setup

#ACTION=="add", SUBSYSTEM=="net", SYSFS{address}=="00:09:18:30:97:02", RUN+="/root/network.sh"
#ACTION=="remove", SUBSYSTEM=="net", SYSFS{address}=="00:09:18:30:97:02",  RUN+="/root/network.sh"

# The first framebuffer is symlinked to /dev/fb
KERNEL=="fb0", SYMLINK+="fb"
# The first rtc device is symlinked to /dev/rtc
KERNEL=="rtc0", SYMLINK+="rtc"
# Try and modprobe for drivers for new hardware
ACTION=="add", DEVPATH=="/devices/*", ENV{MODALIAS}=="?*", RUN+="/sbin/modprobe $env{MODALIAS}"
# Create a symlink to any touchscreen input device
SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{modalias}=="input:*-e0*,3,*a0,1,*18,*", SYMLINK+="input/touchscreen0"



Regards


Tarak Ramgopal Anumolu 
Security Solution Division
SAMSUNG TECHWIN CO.,LTDˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
