Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3LGNrN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:47:13 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48941 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3LGNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <CABWXVkMUFdRKNm76Vc3oJ+Ef9M_MS1xU2TKh=rdyv-t9Cq5V1w@mail.gmail.com>
References: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
	<CABWXVkMUFdRKNm76Vc3oJ+Ef9M_MS1xU2TKh=rdyv-t9Cq5V1w@mail.gmail.com>
Date: Sat, 7 Dec 2013 17:47:09 +0400
Message-ID: <CABWXVkNXzxrZJiYshhsWFRf4fDgUL3=tmFtv23w=sZtZM7Rxgg@mail.gmail.com>
Subject: Re: synaptics: PS/2 touchpad isn't detected if a keyboard key is held
 down on boot
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I inserted a printk into ps2_handle_response(struct ps2dev *ps2dev,
unsigned char data) in "drivers/input/serio/libps2.c" and other
functions in the file.
It really eats scancodes from the keyboard, as I see (0x23 is the 'H'
press scancode). Seems like the scancodes are mixed with reasonable
values. Is it a bug in the controller? Got all this on Lenovo Ideapad
Y550P notebook with Synaptics PS/2 touchpad.

PS2 init
PS2 begin command
PS2 command
PS2 send byte
PS2 end command
PS2 begin command
PS2 command
PS2 send byte
PS2 end command
PS2 init
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0xfa
PS2 handle responce 0x23
PS2 adjust timeout
PS2 end command
PS2 init
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0xfa
PS2 handle responce 0xab
PS2 adjust timeout
PS2 handle responce 0x41
PS2 end command
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0xfa
PS2 end command
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0x23
PS2 handle ack 0xfa
PS2 send byte
PS2 handle ack 0xfa
PS2 end command
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0xfa
PS2 send byte
PS2 handle ack 0xfa
PS2 end command
PS2 begin command
PS2 command
PS2 send byte
PS2 handle ack 0xfa
PS2 end command

On Sat, Dec 7, 2013 at 3:01 PM, Andrey Moiseev <o2g.org.ru@gmail.com> wrote:
> psmouse module is not loaded when I hold down a key on boot (when
> GRUB2 says "loading vmlinuz"), and, in its turn, the PS/2 touchpad
> doesn't work. Latest mainline kernel, latest stable one and probably
> many older ones. I guess i8042's buffer gets full and that confuses
> drivers somehow.
>
> On Fri, Dec 6, 2013 at 9:22 PM, Andrey Moiseev <o2g.org.ru@gmail.com> wrote:
>> This is an ancient bug, I noticed it since I bought my notebook.
>> Synaptics PS/2 touchpad is not detected and is not shown in
>> /dev/input/event* if I hold a keyboard key down when booting just
>> started.
