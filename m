Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3EGGFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:05:11 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58191 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3EGGFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <5188905A.4020703@zytor.com>
References: <5188905A.4020703@zytor.com>
Date: Mon, 6 May 2013 23:05:08 -0700
Message-ID: <CAJiQ=7DDpCUTXasoo8qbrv-g87Ak7NFvKXSn6+cfhKai06yG_A@mail.gmail.com>
Subject: Re: Lenovo Yoga 13 touchpad regression
From: Kevin Cernekee <cernekee@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 10:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hello,
>
> The touchpad on Lenovo Yoga 13 seems to have broken some time between 3.4
> and the current kernel.  The dmesg is full of spewage:
>
> [  256.246481] atkbd serio0: Use 'setkeycodes e03e <keycode>' to make it
> known.
> [  256.251473] atkbd serio0: Unknown key released (translated set 2, code
> 0xbe on isa0060/serio0
>
> ... about once per second; I am wondering if the touchpad is spewing output
> onto the keyboard channel or if there is something else wrong.

>From googling around this looks like a Synaptics unit.

Is it being detected by the ALPS driver?  If so, did it use the ALPS
driver in 3.4?

alps.c was changed to identify several new models, but PS/2 touchpad
identification uses "magic knock sequences" which may be prone to
false positives.  This is something we should watch for.
