Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFDTjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:39:33 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40489 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFDTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:39:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140604175031.GA4406@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com> <20140604092214.GA17528@dhcp-17-89.nay.redhat.com>
 <20140604175031.GA4406@redhat.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 4 Jun 2014 21:39:10 +0200
X-Google-Sender-Auth: AcNpBoN4t03wNcDFQZjLaxsY1iM
Message-ID: <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in kernel loading
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, mjg59@srcf.ucam.org,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, dyoung@redhat.com, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

As per Documentation/SubmitChecklist , please CC linux-api@ on patces
that change the ABI/API. See
https://www.kernel.org/doc/man-pages/linux-api-ml.html.

Also, is there some draft man page for this new system call?

Thanks,

Michael

On Wed, Jun 4, 2014 at 7:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jun 04, 2014 at 05:22:14PM +0800, WANG Chao wrote:
>
> [..]
>> > Index: kexec-tools/kexec/kexec.h
>> > ===================================================================
>> > --- kexec-tools.orig/kexec/kexec.h  2014-06-02 14:34:16.719774316 -0400
>> > +++ kexec-tools/kexec/kexec.h       2014-06-02 14:34:42.010036325 -0400
>> > @@ -156,6 +156,13 @@ struct kexec_info {
>> >     unsigned long kexec_flags;
>> >     unsigned long backup_src_start;
>> >     unsigned long backup_src_size;
>> > +   /* Set to 1 if we are using kexec2 syscall */
>> > +   unsigned long file_mode :1;
>> > +
>> > +   /* Filled by kernel image processing code */
>> > +   int initrd_fd;
>> > +   char *command_line;
>> > +   int command_line_len;
>> >  };
>> >
>> >  struct arch_map_entry {
>> > @@ -207,6 +214,7 @@ extern int file_types;
>> >  #define OPT_UNLOAD         'u'
>> >  #define OPT_TYPE           't'
>> >  #define OPT_PANIC          'p'
>> > +#define OPT_USE_KEXEC2_SYSCALL     's'
>> >  #define OPT_MEM_MIN             256
>> >  #define OPT_MEM_MAX             257
>> >  #define OPT_REUSE_INITRD   258
>> > @@ -230,6 +238,7 @@ extern int file_types;
>> >     { "mem-min",            1, 0, OPT_MEM_MIN }, \
>> >     { "mem-max",            1, 0, OPT_MEM_MAX }, \
>> >     { "reuseinitrd",        0, 0, OPT_REUSE_INITRD }, \
>> > +   { "use-kexec2-syscall", 0, 0, OPT_USE_KEXEC2_SYSCALL }, \
>> >     { "debug",              0, 0, OPT_DEBUG }, \
>> >
>> >  #define KEXEC_OPT_STR "h?vdfxluet:p"
>>
>> This line,
>> #define KEXEC_OPT_STR "h?vdfxluet:p"
>>
>> should be something like,
>> #define KEXEC_OPT_STR "h?vdfxluet:ps"
>
> Thanks chao. I will fix it.
>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
