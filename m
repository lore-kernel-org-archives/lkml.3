Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3IRPhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:37:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56719 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3IRPhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <5239BFB8.4020304@infradead.org>
References: <1828294.VXnhqsmrEo@localhost>
	<5239BFB8.4020304@infradead.org>
Date: Wed, 18 Sep 2013 17:37:20 +0200
Message-ID: <CA+MoWDp0zFXaEhYbwsEV_uMg3H0Nabx9iu25ixyuJvgWGxi=Gg@mail.gmail.com>
Subject: Re: Dependency bug in the uvcvideo Kconfig
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "Jeff P. Zacher" <ad_sicks@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

I've tried to download the .config file from the link on the forum,
but it tries to install something in my browser and the file is not
downloadable for me. Can you provide it over an simpler interface such
as pastebin.com?

Thanks

On Wed, Sep 18, 2013 at 4:59 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> [adding linux-media mailing list]
>
>
> On 09/18/13 06:18, Jeff P. Zacher wrote:
>> Not subscribed, please CC'me in replies:
>>
>> There seems to be a dependency bug in the Kconfig for the uvcvideo kernel
>> module.  If uvcvideo is built in and usb support is built as a module, the
>> kernel build will fail with the obviously missing dependanies.
>>
>>
>> Error logs:
>>
>> * ERROR: Failed to compile the "bzImage" target...
>> *
>> * -- Grepping log... --
>> *
>> *  SHIPPED scripts/genksyms/keywords.hash.c
>> *  SHIPPED scripts/genksyms/parse.tab.h
>> *  SHIPPED scripts/genksyms/parse.tab.c
>> *  HOSTCC  scripts/genksyms/lex.lex.o
>> *scripts/genksyms/lex.lex.c_shipped: In function ‘yylex1’:
>> *scripts/genksyms/lex.lex.c_shipped:904:1: warning: ignoring return value of
>> ‘fwrite’, declared with attribute warn_unused_result [-Wunused-result]
>> *--
>> *  CC      drivers/video/console/font_8x16.o
>> *  CC      drivers/video/console/softcursor.o
>> *  CC      sound/core/seq/seq_memory.o
>> *  CC      drivers/video/console/fbcondecor.o
>> *  CC      sound/core/seq/seq_queue.o
>> *drivers/video/console/fbcondecor.c:511:6: warning: function declaration isn’t
>> a prototype [-Wstrict-prototypes]
>> *--
>> *(.text+0xf8fb1): undefined reference to `usb_submit_urb'
>> *drivers/built-in.o: In function `uvc_init':
>> *uvc_driver.c:(.init.text+0x908a): undefined reference to
>> `usb_register_driver'
>> *drivers/built-in.o: In function `uvc_cleanup':
>> *uvc_driver.c:(.exit.text+0x67e): undefined reference to `usb_deregister'
>> *make: *** [vmlinux] Error 1
>> *--
>> * Running with options: --lvm --menuconfig all
>> * Using genkernel.conf from /etc/genkernel.conf
>> * Sourcing arch-specific config.sh from
>> /usr/share/genkernel/arch/x86_64/config.sh ..
>> * Sourcing arch-specific modules_load from
>> /usr/share/genkernel/arch/x86_64/modules_load ..
>> *
>> * ERROR: Failed to compile the "bzImage" target...
>> *
>> * -- End log... --
>>
>> Compiling uvc as a module allows the compilation to complete.
>>
>> Platform x86_64
>>
>> Ref: http://forums.gentoo.org/viewtopic-p-7398782.html#7398782
>>
>>
>> -- Jeff P. Zacher
>> ad_sicks@yahoo.com
>
>
> --
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
