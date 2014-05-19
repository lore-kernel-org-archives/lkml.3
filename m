Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaESTj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:39:57 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61330 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaESTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJLKQiC4zwYJ9dpVvELoYBKZ4OFsqKdQXQW9OyDwsdvmg@mail.gmail.com>
References: <20140417202209.GA30268@www.outflux.net>
	<CAGXu5jJLKQiC4zwYJ9dpVvELoYBKZ4OFsqKdQXQW9OyDwsdvmg@mail.gmail.com>
Date: Mon, 19 May 2014 15:39:54 -0400
Message-ID: <CAN+gG=FDjtX9Sz9Hy=NT0zJV6y0sbJLJav=S0S2V=+v++EE6bg@mail.gmail.com>
Subject: Re: [PATCH] HID: core: fix validation of report id 0
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Simon Wood <simon@mungewell.org>,
        linux-input <linux-input@vger.kernel.org>,
        Roland Bosa <rbosa@logitech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 3:01 PM, Kees Cook <keescook@chromium.org> wrote:
> Pinging on this patch... I don't see it in -next yet. I've had more
> reports of trouble with logitech devices, and this seems to solve the
> problem.
>
> -Kees
>
> On Thu, Apr 17, 2014 at 1:22 PM, Kees Cook <keescook@chromium.org> wrote:
>> Some drivers use the first HID report in the list instead of using an
>> index. In these cases, validation uses ID 0, which was supposed to mean
>> "first known report". This fixes the problem, which was causing at least
>> the lgff family of devices to stop working since hid_validate_values
>> was being called with ID 0, but the devices used single numbered IDs
>> for their reports:
>>
>> 0x05, 0x01,         /*  Usage Page (Desktop),                   */
>> 0x09, 0x05,         /*  Usage (Gamepad),                        */
>> 0xA1, 0x01,         /*  Collection (Application),               */
>> 0xA1, 0x02,         /*      Collection (Logical),               */
>> 0x85, 0x01,         /*          Report ID (1),                  */
>> ...
>>
>> Reported-by: Simon Wood <simon@mungewell.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: stable@vger.kernel.org
>> ---

Oops, sorry, I should have commented on it earlier:

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin
