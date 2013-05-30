Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967603Ab3E3GXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:23:20 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50809 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967549Ab3E3GXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <878v2xmgmw.fsf@rustcorp.com.au>
References: <20130529102735.3ce72ecc@endymion.delvare>
	<878v2xmgmw.fsf@rustcorp.com.au>
Date: Thu, 30 May 2013 11:53:10 +0530
Message-ID: <CAK7N6vpv6JpsXEdjLOUd-+7+y=DB9Q-zcMdj12iZWu=bGkAieQ@mail.gmail.com>
Subject: Re: What is listed in /sys/module?
From: anish singh <anish198519851985@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Jean Delvare <khali@linux-fr.org> writes:
>> Hi Greg, Rusty,
>>
>> I have a question related to /sys/module and can't seem to find the
>> answer by myself so I hope you can explain.
>>
>> I noticed that /sys/module contains more than /proc/modules. At first I
>> thought that any potentially modular piece of code would show up
>> in /sys/module, so /sys/module would include both actual modules and
>> "built-in modules".
>>
>> However I then noticed that some built-in modules do _not_ show up
>> in /sys/module. For example, I have USB and I2C core support built into
>> my 3.9.4 kernel, /sys/module/usbcore exists but /sys/module/i2c_core
>> does not. CONFIG_SENSORS_W83795=y did not give me /sys/module/w83795
>> either.
>
> Yes.  /sys/module entries are created for builtin "modules" with
> parameters.  This is because, the module names are discovered by
So documentation is wrong about that.
> scouring the parameters: see param_sysfs_builtin().
>
> Two things to note about builtin modules:
>
> 1) There is nothing other than parameters in /sys/module/, except a
>    uevent which is used for managing the parameters.  So, without
>    parameters, it would be an empty directory.
>
> 2) We actually do generate a list of builtin modules these days, called
>    modules.builtin.  So we could generate sysfs dirs from this.
As I understand modules.builtin is the output of the kernel compilation.
So if we want to make /sys/module consistent then this file needs to
be parsed by kernel and corresponding sysfs created but what is the
point of creating just the sysfs without having any parameters information
which is why this /sys/module exists in the first place right?
>
> If you want to make it consistent, I look forward to your patch!
I would be interested here.
>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
