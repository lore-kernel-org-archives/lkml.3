Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbbA0Rit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:38:49 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39863 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbbA0Riq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:38:46 -0500
Message-ID: <54C7CD1C.1060601@ahsoftware.de>
Date: Tue, 27 Jan 2015 18:38:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de> <54C78524.3070901@nod.at> <54C7881F.6020501@ahsoftware.de> <20150127142120.GA3351@pd.tnic> <54C7C2EC.7010605@ahsoftware.de> <20150127172415.GC25043@home.goodmis.org>
In-Reply-To: <20150127172415.GC25043@home.goodmis.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 18:24 schrieb Steven Rostedt:

> For most people a message in dmesg is not very useful. What you are asking for
> is to print a characteristic of a device. Something that someone might want to
> check much later in boot, where, as Boris stated, the dmesg could have been
> flushed (by systemd, which loves to write stuff to the kernel buffers), and
> there's no way to find out this information. The print message is long gone.
> Having a static location like sysfs is the proper place, because user space
> tools can always access it.
>
> Is this something a tool would like to find out? If so, parsing dmesg is not
> the way to go. Looking it up in sysfs is.

Oh, systemd.

Anyway, I like(d) Linux because it didn't had a splash screen and used 
to spit out all types of information on the screen where it could be 
easily seen or found (in contrast other OS which try to hide all 
technical details from users).

Of course, times are changing, including the amount of stuff printed on 
screen. But I still find it much much easier to grep on the output of 
dmesg than to search through thousands files in sysfs. Even if that can 
be done with grep too (kind of). But it's much more complicated because 
grep doesn't connect the file name with the content, so you need more 
complicated stuff to combine both in order to search for and find 
something in sysfs.

Regards,

Alexander Holler
