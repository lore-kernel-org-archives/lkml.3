Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbbA0RxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:53:23 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30811 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbbA0RxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:53:21 -0500
X-IronPort-AV: E=Sophos;i="5.09,476,1418112000"; 
   d="scan'208";a="55532566"
Message-ID: <54C7D08E.8030309@broadcom.com>
Date: Tue, 27 Jan 2015 18:53:18 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        Richard Weinberger <richard@nod.at>, <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de> <54C78524.3070901@nod.at> <54C7881F.6020501@ahsoftware.de> <20150127142120.GA3351@pd.tnic> <54C7C2EC.7010605@ahsoftware.de> <20150127172415.GC25043@home.goodmis.org> <54C7CD1C.1060601@ahsoftware.de>
In-Reply-To: <54C7CD1C.1060601@ahsoftware.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/15 18:38, Alexander Holler wrote:
> Am 27.01.2015 um 18:24 schrieb Steven Rostedt:
>
>> For most people a message in dmesg is not very useful. What you are
>> asking for
>> is to print a characteristic of a device. Something that someone might
>> want to
>> check much later in boot, where, as Boris stated, the dmesg could have
>> been
>> flushed (by systemd, which loves to write stuff to the kernel
>> buffers), and
>> there's no way to find out this information. The print message is long
>> gone.
>> Having a static location like sysfs is the proper place, because user
>> space
>> tools can always access it.
>>
>> Is this something a tool would like to find out? If so, parsing dmesg
>> is not
>> the way to go. Looking it up in sysfs is.
>
> Oh, systemd.
>
> Anyway, I like(d) Linux because it didn't had a splash screen and used
> to spit out all types of information on the screen where it could be
> easily seen or found (in contrast other OS which try to hide all
> technical details from users).

What ends up in kernel log is still a fraction of what is going on in 
the kernel.

> Of course, times are changing, including the amount of stuff printed on
> screen. But I still find it much much easier to grep on the output of
> dmesg than to search through thousands files in sysfs. Even if that can
> be done with grep too (kind of). But it's much more complicated because
> grep doesn't connect the file name with the content, so you need more
> complicated stuff to combine both in order to search for and find
> something in sysfs.

Ever used rgrep or grep -R. Anyway, if this is you use-case what about 
the gazillion other pieces of info in the kernel. When moving in that 
direction you can be sure dmesg will flush out.

Regards,
Arend

> Regards,
>
> Alexander Holler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

