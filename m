Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3DXBfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:35:03 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45310 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3DXBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:35:01 -0400
MIME-Version: 1.0
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 03:34:39 +0200
Message-ID: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
Subject: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

what's the intention of:
  e90c83f757fffdacec8b3c5eee5617dcc038338f ?
  x86: Select HAS_PERSISTENT_CLOCK on x86

It unconditionally sets:
  HAS_PERSISTENT_CLOCK
but:
  RTC_SYSTOHC
got a depends on !HAS_PERSISTENT_CLOCK

This makes it impossible to sync the system time from the RTC on x86.
What's going on here?

Thanks,
Kay
