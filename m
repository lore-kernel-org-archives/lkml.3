Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3FJHYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:24:08 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45004 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3FJHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:24:07 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <51B57A7A.9040501@canonical.com>
References: <20130606013518.GA9092@localhost>
	<51B038E3.30800@canonical.com>
	<20130606072856.GA32274@localhost>
	<51B427A4.9030805@canonical.com>
	<20130610015530.GA18906@localhost>
	<51B57A7A.9040501@canonical.com>
Date: Mon, 10 Jun 2013 09:24:05 +0200
X-Google-Sender-Auth: 9ZeCZjMBILfjvKATXkx3uIa3Sfo
Message-ID: <CAKMK7uFoa3A=u7HNTBMKV7xYQ8q4XQCxSO5eHTekYx7oTzBbZQ@mail.gmail.com>
Subject: Re: [inconsistent HARDIRQ usage] &dev->mode_config.idr_mutex at drm_mode_object_find()
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 9:04 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> ^ Stacktrace points at the warning being called from panic. At that point I no longer trust anything to be sane.
> I don't know much about the panic handling in drm, but it's definitely not related to your original issue.

The locking in the current drm panic handler is pretty much terminally
broken. At best we're trying not too flood dmesg too badly when it
happens.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
