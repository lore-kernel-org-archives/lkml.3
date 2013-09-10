Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3IJROg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:14:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56640 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3IJROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:14:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130909050147.GA3899@osiris>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com> <522D32F6.4020705@roeck-us.net> <20130909050147.GA3899@osiris>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 11 Sep 2013 01:14:11 +0800
Message-ID: <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 1:01 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Sun, Sep 08, 2013 at 07:31:18PM -0700, Guenter Roeck wrote:
>> On 09/08/2013 07:31 PM, Greg Kroah-Hartman wrote:
>> >On Sun, Sep 08, 2013 at 07:24:19PM -0700, Guenter Roeck wrote:
>> >>On 09/08/2013 06:59 PM, Greg Kroah-Hartman wrote:
>> >>>On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
>> >>>>mips allmodconfig fails with
>> >>>>
>> >>>>ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
>> >>>>undefined!
>> >>>>
>> >>>>which is due to LUSTRE using copy_from_user_page which is not exported by any
>> >>>>architecture.
>> >>>
>> >>>Any, or just these arches?
>> >>>
>> >>Other architectures implement it as define as far as I can see.
>> >
>> >Then why would it be a problem?
>> >
>> It isn't a problem for those other architectures. Mostly it is mapped to functions like memcpy().
>>
>> Guenter
>>
>> >>>>Unfortunately, LUSTRE can only be built as module, so there is no
>> >>>>easy fix.
>> >>>
>> >>>Can't we just export the functions for those arches?  Surely lutre
>> >>>isn't the first/only driver that needs this?
>> >>>
>> >>That would be another option.
>> >>
>> >>Actually, turns out Geert submitted a patch to do this for mips already, and Ralf applied it:
>> >>
>> >>https://lkml.org/lkml/2013/9/5/111
>> >>
>> >>So please forget this patch. If sh/xtensa actually need it, we can do the same there.
>> >
>> >Sounds good to me, consider it forgotten :)
>> >
>> >greg k-h
>
> The proper "fix" seems to be to get rid of this new usage of
> copy_from_user_page() in lustre.
> The code in question is nothing but a copy of __access_remote_vm()
> from mm/memory.c...
>
The problem is access_process_vm() is not exported since certain
version of kernel including the latest. According to Christoph in the
other mail, access_process_vm() is also a core mm function that is not
supposed to be exported. Then what kind of change shall we make in
order to keep current functionality?

Thanks,
Bergwolf
