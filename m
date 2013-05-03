Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256Ab3ECLew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:34:52 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:44751 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367Ab3ECLeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:34:50 -0400
MIME-Version: 1.0
In-Reply-To: <518284E6.7040503@intel.com>
References: <51814943.7000604@intel.com>
	<20130501182138.GA17550@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com>
	<518284E6.7040503@intel.com>
Date: Fri, 3 May 2013 13:34:50 +0200
X-Google-Sender-Auth: AzhJvexf1eoSPz4AaUK7ceWdWfo
Message-ID: <CAMuHMdWSVUcwkY=xn+HjbruLxsc8Eqq=CWX78CdUc1+MAwCVhg@mail.gmail.com>
Subject: Re: mei file2alias compile error
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "SamuelOrtiz@kroah.com" <SamuelOrtiz@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:23 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 05/01/2013 11:50 PM, Winkler, Tomas wrote:
>>> On Wed, May 01, 2013 at 09:56:35AM -0700, Dave Hansen wrote:
>>>> Linus's current git isn't compiling for me:
>>>>>   HOSTCC  scripts/mod/file2alias.o
>>>>> /home/davehans/linux.git/scripts/mod/file2alias.c: In function
>>> ‘do_mei_entry’:
>>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: error:
>>> ‘OFF_mei_cl_device_id_name’ undeclared (first use in this function)
>>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: note: each
>>> undeclared identifier is reported only once for each function it appears in
>>>>> /home/davehans/linux.git/scripts/mod/file2alias.c: At top level:
>>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1146:1: error:
>>> ‘SIZE_mei_cl_device_id’ undeclared here (not in a function)
>>>>
>>>> I confirmed that this commit: e5354107e is the one causing it for me.
>>>> My .config is here:
>>>>
>>>>     http://sr71.net/~dave/linux/config-3.9-meibad
>>>>
>>>> Note that I don't even have CONFIG_INTEL_MEI enabled with this config.
>>>
>>> I don't have CONFIG_INTEL_MEI set either, and I can't duplicate this.
>>> Samuel and Tomas, can you please track this down?
>>
>> I cannot reproduce it as well. I've tried with v3.9 and also with the latest tip.
>
> I did some more poking around.  I was building with O= to put the
> binaries in another dir.  When I saw the error, one of the first things
> I did was do a "make mrproper" on the binary directory.  But, I never
> did one one the source directory.  Doing that seems to have made this go
> away.  There must have been some build gunk in the source directory
> causing this.

Same here.

Removing "scripts/mod/devicetable-offsets.h" from the source directory fixes it.
Unfortunately I forgot to check the date on the bogus
scripts/mod/devicetable-offsets.h,
so I don't know when it was generated.

Usually, if you build in the source directory, a subsequent build in the output
directory will tell you to run "make mrproper" in the source directory. That
obviously didn't happen.

Note that I did run "make tags" in the source directory. So far that
never caused
problems. Just checked, it does not create scripts/mod/devicetable-offsets.h.

JFYI, putting back scripts/mod/devicetable-offsets.h by copying from a
freshly generated one in the output directory, with the mei lines removed,
resurrects the problem.
Even after touching scripts/mod/devicetable-offsets.c afterwards, it is not
regenerated.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
