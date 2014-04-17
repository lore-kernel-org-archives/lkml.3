Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaDQWcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:32:03 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47165 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDQWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:31:58 -0400
MIME-Version: 1.0
Date: Fri, 18 Apr 2014 00:31:57 +0200
Message-ID: <CAKWSe6DD77urqqTxya4FAE+VrJ1XD9UQ8u+x5DYefvO1VosLfA@mail.gmail.com>
Subject: 3.15-rc1: Endless "Disabling PPGTT because VT-d is on" messages in /var/log/messages
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[hoping I persuaded gmail to get my old text-only email settings back, grrr]


Noticed that my root fs was filling up, and found out that /var/log/messages was
 approaching 2GB of space, most of which were as per $subject. To give an idea
 of the magnitude, here's a snippet from a saved sample of /var/log/messages:

[root@xbox log]# grep  "Disabling PP" messages.save.head |head -1
Apr 15 03:44:10 xbox kernel: [    3.115126] [drm] Disabling PPGTT
because VT-d is on
[root@xbox log]# grep  "Disabling PP" messages.save.head |tail -1
Apr 15 03:45:50 xbox kernel: [  130.165219] [drm] Disabling PPGTT
because VT-d is on
[root@xbox log]# grep -c "Disabling PP" messages.save.head
610

Or from the dmesg ring:

[root@xbox log]# dmesg|head
[22446.690572] [drm] Disabling PPGTT because VT-d is on
[22446.690616] [drm] Disabling PPGTT because VT-d is on
[22446.704560] [drm] Disabling PPGTT because VT-d is on
[22446.706747] [drm] Disabling PPGTT because VT-d is on
[22446.720202] [drm] Disabling PPGTT because VT-d is on
[22446.722447] [drm] Disabling PPGTT because VT-d is on
[22446.724850] [drm] Disabling PPGTT because VT-d is on
[22446.727268] [drm] Disabling PPGTT because VT-d is on
[22446.733052] [drm] Disabling PPGTT because VT-d is on
[22446.735319] [drm] Disabling PPGTT because VT-d is on



Are there patches for this issue, or is a workaround available to prevent a
 filesystem full condition on my root fs?


This is on a Dell Latitude E6420 laptop, Fedora 19 x86_64, onboard
 Intel video card... yes, I have an old A08 BIOS, but I've never seen
 this issue while regularly updating my mainline kernel weekly or so...


Available for more details if needed, thanks in advance,

--alessandro

"don't underestimate the things that I will do"

 (Adele, "Rolling In The Deep")
