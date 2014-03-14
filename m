Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaCNFOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:14:24 -0400
Received: from mail-ee0-f65.google.com ([74.125.83.65]:64637 "EHLO
	mail-ee0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaCNFOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:14:17 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2014 01:14:17 EDT
MIME-Version: 1.0
Date: Fri, 14 Mar 2014 12:58:04 +0800
Message-ID: <CANHbGWs2LPs8eZ2s-4kV9tOG0Dg2To0kezax5pJJy_QQ+PvDqw@mail.gmail.com>
Subject: Question for ARM926T mtune values in ARM Makfile
From: V JobNickname <workofv@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ARM926T, the value in the Makefile are assigned to arm9tdmi.
Actually all ARM9xxx are assigned by value arm9tdmi.

But in some cross compile GCC toolchains, such as from Buildroot, they
have different specified tune value
for example, in buildroot GCC

config BR2_GCC_TARGET_TUNE
...
default arm920 if BR2_arm920
default arm920t if BR2_arm920t
default arm922t if BR2_arm922t
default arm926ej-s if BR2_arm926t
default arm1136j-s if BR2_arm1136j_s
default arm1136jf-s if BR2_arm1136jf_s
default arm1176jz-s if BR2_arm1176jz_s
default arm1176jzf-s if BR2_arm1176jzf_s
...

and by "man gcc"
-mtune is similar to mcpu
and in mcpu list includes arm9tdmi and arm926ej-s

Should mtune value in Kernel ARM Makefile for ARM926T be modified to
tune-$(CONFIG_CPU_ARM926T)      =-mtune=arm926ej-s

and will this have better instruction tune by GCC for ARM926T?
