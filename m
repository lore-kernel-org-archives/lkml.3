Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3KXQg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:36:57 -0500
Received: from mout.web.de ([212.227.15.14]:52057 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3KXQg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:36:56 -0500
MIME-Version: 1.0
Message-ID: <trinity-1c222a26-5aad-4747-9ae3-69cce71bd67e-1385311014634@3capp-webde-bs35>
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Grub2 skips standard linux initialization code ?
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Nov 2013 17:36:54 +0100 (CET)
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:U1NwtwK2VKTTQ08CMJsMNbAE9DeZpDS/bCrKdDyUqtd
 N+Cz7/wYX8z0Ly5pHmG4M9/AWrI14hWgqaNhFho87CV2XLnqf1
 OOtq5Gn7MgQp/hHSonhZUDCaSI2MjxzKRCZr1rscPlWU1QDdUn
 EqvR4uZhH66AiRTMcu5Nd0ucYcnwA6o5S5RPKsmU9+kSPgvNEx
 u62d3C4fyEE1jO/JBP076rD36hNd3Vz0FNwjN2DZszab46cJm3
 IlBONmrCHkiyT75cla6CvktL1MKdzR1cU7chL0vOdP2mKRmHLS
 TOuzAa7QXAVNbwNsSf5dtU0xUQ7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

regarding https://bugs.launchpad.net/ubuntu/+source/syslinux/+bug/930447 

Grub2 "accidentally" heals a problem for systems which cannot boot PAE enabled kernels.  This happens because grub2 apparently jumps into the kernel at a different entry point, so CPUID checking (check for PAE for example) apparently does not occur.

Here are some 100 affected users (including me) which cannot boot recent Ubuntu (not even lubuntu, which is meant for that) Installation disk on their older hardware, which makes installation a pain.

This is because Pentium M cpu´s for example often can do PAE, but they incorrectly report.

The ubuntu installer disc does "traditional" boot via syslinux, whereas the installed system boots via grub2. That explains why you can upgrade from ubuntu 12.04 to 13.10 and have a workable system, but you cannot freshly install 13.10.   The most absurd thing is: You cannot even install Lubuntu or Xubuntu, which is especially designed to be used on older hardware. I guess Pentium M is a process which is still widely used.

My question is:
1. Why does Grub2 think it`s good to skip x86 linux initializiation code? Is that good or bad?
2. Besides that, wouldn`t it be extremly helpful to add a quirk or skip routine to the kernel initialization code? (kernelparam: "no-pae-ceck" for example). 

regards
roland
