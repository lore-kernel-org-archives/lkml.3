Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3GQPvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:51:11 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46040 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3GQPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <1371937599.17761.19.camel@scapa>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	<1371937599.17761.19.camel@scapa>
Date: Wed, 17 Jul 2013 10:51:07 -0500
Message-ID: <CAMP44s3uz5fyXKLgS8TFroCVy7Rx-zpXYvX4TGFDX=65ki5T6w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 4:46 PM, Yves-Alexis Perez <corsac@debian.org> wrote:
> On dim., 2013-06-09 at 19:01 -0400, Matthew Garrett wrote:
>> The first two patches in this series are picked from other patchesets aimed at
>> solving similar problems. The last simply unregisters ACPI backlight control
>> on Windows 8 systems when using an Intel GPU. Similar code could be added to
>> other drivers, but I'm reluctant to do so without further investigation as
>> to the behaviour of the vendor drivers under Windows.
>
> Hi,
>
> I've read this thread coming from
> https://bugzilla.kernel.org/show_bug.cgi?id=51231 and tried the patches
> on a Lenovo ThinkPad X230 with intel graphics.
>
> The problem with thoses fixes is that they still introduce a regression
> in how the brightness is handled, at least for me.

For me too.

> Before Linux support for acpi_osi("Windows 2012") (and when booting with
> acpi_osi="!Windows 2012"), brightness keys were handled by the kernel
> just fine, whether in console, in the display manager or in my desktop
> environment (Xfce). xfce4-power-manager just needs to be told that the
> brightness keys are already handled and it doesn't need to do anything.

How do you tell xfce4-power-manager that?

For me everything works fine when acpi_osi="!Windows 2012", which is
why I wrote a patch for this particular laptop.

http://article.gmane.org/gmane.linux.acpi.devel/60969

> So can the previous behavior be actually restored?

It *should*. The #1 rule of the Linux kernel is to never ever break
user-space, isn't it?

> Please keep me on CC: on replies, I'm not subscribed to the various
> lists.

You don't need to ask that in mailing lists that don't have reply-to
munged (sane ones), and vger ones don't.

Cheers.

-- 
Felipe Contreras
