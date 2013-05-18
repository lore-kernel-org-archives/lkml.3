Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3ERNlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 09:41:51 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54916 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3ERNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 09:41:49 -0400
Message-ID: <51978519.7090907@gmail.com>
Date: Sat, 18 May 2013 15:41:45 +0200
From: Andy Chernyak <andy.chernyak@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: vt8500-wm8505-linux-kernel@googlegroups.com
CC: Alexey Charkov <alchark@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tomi.valkeinen@ti.com,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 4/4] fb: vt8500: Add VGA output support to wm8505fb driver.
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz> <1368868514-18975-5-git-send-email-linux@prisktech.co.nz> <CABjd4Yxrk3hXnB5f6u+1HcJjymDZbtQ1F1HXkZ2dzF3dwCrWhg@mail.gmail.com>
In-Reply-To: <CABjd4Yxrk3hXnB5f6u+1HcJjymDZbtQ1F1HXkZ2dzF3dwCrWhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 03:28 PM, Alexey Charkov wrote:
> 2013/5/18 Tony Prisk <linux@prisktech.co.nz>:
>
>>         /* Virtual buffer size */
>> @@ -167,7 +176,12 @@ static int wm8505fb_init_hw(struct fb_info *info)
>>
>>         /* black magic ;) */
>>         writel(0xf,                    fbi->regbase + REG_GOVRH_FHI);
>> -       writel(4,                      fbi->regbase + REG_GOVRH_DVO_SET);
>> +
>> +       if (fbi->interface == INTERFACE_VGA)
>> +               writel(0xe, fbi->regbase + REG_GOVRH_DVO_SET);
>> +       else
>> +               writel(4, fbi->regbase + REG_GOVRH_DVO_SET);
> I don't remember if HDMI is yet another option for this register or
> not... If it is, it would probably warrant defining fbi->interface as
> an enum and changing this if-else into a switch statement to let the
> compiler add its checks/warnings.
HDMI output can work simultaneously with LCD (on 8850 at least), which
fbi->interface in its current form would not allow to express.

> +       if (fbi->interface == INTERFACE_VGA)
> +               writel(h_sync,  fbi->regbase + REG_GOVRH_VGA_HSYNW);
> Will it misbehave on LCD if you write to the VGA register unconditionally?
>
Can we have 3 flags, something like LCD_ON, VGA_ON, HDMI_ON instead of
enum for video interface selection?

Regards,
Andy.
