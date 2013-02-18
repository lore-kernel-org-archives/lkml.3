Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3BROdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:33:12 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54371 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3BROdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:33:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130217141757.GA5228@jack.whiskey>
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
	<1360338220-12753-2-git-send-email-ruslan.bilovol@ti.com>
	<20130210235125.GA8098@jack.whiskey>
	<CAB=otbSpspZ9Z_fOpBvE1mPtt+JwZydZrgcR2LdkD_4CrGa_eg@mail.gmail.com>
	<20130217141757.GA5228@jack.whiskey>
Date: Mon, 18 Feb 2013 16:33:06 +0200
X-Google-Sender-Auth: HzB0unopMSqTSkjztwYVWtnu0Xw
Message-ID: <CAB=otbS-_YgMnP9G_MJ2n7wGAiRP-1-WeXgg8SvC-w9EGas5ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] OMAP4: DSS: Add panel for Blaze Tablet boards
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Andi Shyti <andi.shyti@gmail.com>
Cc: Andi Shyti <andi@etezian.org>, tomi.valkeinen@ti.com,
        FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Sun, Feb 17, 2013 at 4:17 PM, Andi Shyti <andi.shyti@gmail.com> wrote:
>> >> +     char name[30];
>> >> +     char buf[50];
>> >> +
>> >> +     if (size >= sizeof(buf))
>> >> +             size = sizeof(buf);
>> >
>> > what's the point of this?
>>
>> This is a way to limit copied from userspace data by available buffer size,
>> widely used in current kernel sources. Are you implying there is some
>> better (more graceful) way?
>
> No indeed :)
> There is no other way, sorry for polluting the review :)
>
>> >> +     if ((pins[2] & 1) || (pins[3] & 1)) {
>> >> +             lanes |= (1 << 1);
>> >> +             ret |= tc358765_write_register(dssdev, PPI_D0S_CLRSIPOCOUNT,
>> >> +                                                     board_data->clrsipo);
>> >> +     }
>> >> +     if ((pins[4] & 1) || (pins[5] & 1)) {
>> >> +             lanes |= (1 << 2);
>> >> +             ret |= tc358765_write_register(dssdev, PPI_D1S_CLRSIPOCOUNT,
>> >> +                                                     board_data->clrsipo);
>> >> +     }
>> >> +     if ((pins[6] & 1) || (pins[7] & 1)) {
>> >> +             lanes |= (1 << 3);
>> >> +             ret |= tc358765_write_register(dssdev, PPI_D2S_CLRSIPOCOUNT,
>> >> +                                                     board_data->clrsipo);
>> >> +     }
>> >> +     if ((pins[8] & 1) || (pins[9] & 1)) {
>> >> +             lanes |= (1 << 4);
>> >> +             ret |= tc358765_write_register(dssdev, PPI_D3S_CLRSIPOCOUNT,
>> >> +                                                     board_data->clrsipo);
>> >> +     }
>> >
>> > Can't this be done in one single multiwrighting command since
>> > this registers are consecutive?
>> >
>> > You build once the array to write and you send it at once.
>>
>> In this particular case I disagree. Yes, it will be a little bit
>> faster, however:
>> 1) we write this for panel initialization only (so no impact in other cases)
>> 2) multiwriting of array will make code reading more difficult
>>
>> So I would like to leave it as-is
>> Same is for next your similar comment.
>
> If the hw is providing us some ways for simplifying the code I
> would use it. In this case we are talking about the i2c feature
> of multiwriting and multireading.
>
> Let's assume that we want to write on 8 different consecutive
> registers. In my opinion this aproach is quite "heavy":
>
>   uX register;
>
>   register = value1;
>   i2c_write(REG1, register);
>
>   register = value2;
>   i2c_write(REG2, register);
>
>   ...
>
> Usually what I do is this:
>
>   uX register[8];
>
>   for (i = 0; i < 8; i++)
>     register |= valuei << i; (or register[i] = valuei or whatever)
>
>   i2c_multi_write(REG, register, 8);
>
> of course this is a simplified example in pseudocode. I think
> it's more readable and we are making a better use of the i2c
> protocol.
>
> In your case you have some if statement that are making the multi
> writing more difficult, but still is not impossible.
>
> At the end it's still a matter of taste, so that you are free to
> choose whatever you prefer :)

Thank you for reviewing this.
Unfortunately, this driver is not accepted due to future OMAP DSS rework.

I will take into account your comments when will reimplement it for new
DSS architecture.

Thanks and best regards,
Ruslan

>
> Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
