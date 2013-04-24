Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3DXDvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:51:47 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36745 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab3DXDvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP12D-H_E3WbWYgrbtvA_6wq=DhpiaLU_hGRgD6ga=_1x-A@mail.gmail.com>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org> <CAPXgP12D-H_E3WbWYgrbtvA_6wq=DhpiaLU_hGRgD6ga=_1x-A@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 05:51:24 +0200
Message-ID: <CAPXgP10R0HSqOmq6LEW-Wqki1c7TyiemGwtUBEOopgZjWBNoOA@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 5:33 AM, Kay Sievers <kay@vrfy.org> wrote:

> Also:
>   $ cat /sys/class/rtc/rtc0/hctosys
>   0
> always carried "1", and this now breaks setups which expect an
> automatically created symlink /dev/rtc to the actual "system rtc".

We used to do this in upstream standard udev rules:
  SUBSYSTEM=="rtc", ATTR{hctosys}=="1", MODE="0644"
  http://cgit.freedesktop.org/systemd/systemd/tree/rules/50-udev-default.rules#n18

If that information is expected to be gone now, we need to update some
tools. Whats' the proper way now to find the "system rtc" to use?

Kay
