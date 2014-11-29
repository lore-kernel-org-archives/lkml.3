Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaK2Avn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 19:51:43 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42848 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaK2Avm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 19:51:42 -0500
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Sat, 29 Nov 2014 01:51:20 +0100
Message-ID: <CAA85sZs6u08DxzV3gF3r-=LvBry0vUFMtfvG1pXRbz1FG6wnag@mail.gmail.com>
Subject: Re: 3.18-rc regression: drm/nouveau: use shared fences for readable objects
To: maarten.lankhorst@canonical.com
Cc: mike@marineau.org, tobias.johannes.klausmann@mni.thm.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to but in like this but I'm suffering from the same kind of
deadlocks with nouveau...

The really odd thing is that i could boot some -rc6+ kernel without
problems but it hung
while playing video and then it refused to start properly again.


Anyway, to quote Maarten:
Ok that most likely means the interrupt based wait is borked somehow,
so lets find \
out why..

I fear that this happens because of a race in the interface, so my
first attempt will \
rule out abuse of the nvif api by nouveau_fence.c

Can you test below patch with the default wait function?
---

I tried the patch, straight on Linus' master and it didn't change
anything for me :(
