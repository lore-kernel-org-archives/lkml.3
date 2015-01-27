Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbbA0ORK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:17:10 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62242 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbbA0ORI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:17:08 -0500
MIME-Version: 1.0
In-Reply-To: <20150127132127.GA869@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201412041857.49341@pali> <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
 <201501262016.52079@pali> <CAL_JsqL_EEg7tC-q8wV5v8jAfPSiri4z19iJfz2r7zntRwPyOg@mail.gmail.com>
 <20150127132127.GA869@amd>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 27 Jan 2015 08:16:45 -0600
Message-ID: <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 7:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2015-01-26 14:33:21, Rob Herring wrote:
>> On Mon, Jan 26, 2015 at 1:16 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
>> > This patch will cause that decompressor store full ATAG structure into DT tree ("/atags"):
>> >
>
>> > +       /* include the terminating ATAG_NONE */
>> > +       atag_size = (char *)atag - (char *)atag_list + sizeof(struct tag_header);
>> > +       setprop(fdt, "/", "atags", atag_list, atag_size);
>> > +
>> >         if (memcount) {
>> >                 setprop(fdt, "/memory", "reg", mem_reg_property,
>> >                         4 * memcount * memsize);
>> >
>> >
>> >
>> > And this patch will export ATAG structure from DT tree ("/atags") into /proc/atags file:
>>
>> Please properly send your patches.
>
> Actually, when sending patches for discussion, this is format easier
> to read.

Some people might prefer them as attachments too...

>> > Some userspace applications needs access to ATAG structure where can be stored some information passed
>> > from bootloader to kernel. Example is Nokia N900 device and NOLO bootloader which provides information
>> > about bootreason (device was started by power button or by alarm or restarted...) and bootmode (normal
>> > mode or device update mode).
>>
>> This goes in the commit message.
>>
>> These would be non-standard fields which are not upstream. I don't
>> know that we care in that case...
>
> Other devices are going to care about boot reason, too, and we might
> as well be compatible...

What other devices? Where is bootreason in the list of ATAGS:

#define ATAG_MEM        0x54410002
#define ATAG_VIDEOTEXT  0x54410003
#define ATAG_RAMDISK    0x54410004
#define ATAG_INITRD     0x54410005
#define ATAG_INITRD2    0x54420005
#define ATAG_SERIAL     0x54410006
#define ATAG_REVISION   0x54410007
#define ATAG_VIDEOLFB   0x54410008
#define ATAG_CMDLINE    0x54410009
#define ATAG_ACORN      0x41000101
#define ATAG_MEMCLK     0x41000402

Rob
