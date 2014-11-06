Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaKFXkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:40:00 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58169 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKFXj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:39:58 -0500
Date: Fri, 07 Nov 2014 07:39:49 +0800
Subject: Re: [PATCH] include/linux/audit.h: Move dummy audit_file() from
 !AUDIT area to !AUDITSYSCALL area
Message-ID: <p3in3107wrybjk5en98pym0r.1415316933281@email.android.com>
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6Ne60i009112

I intended to put it here for topology symmetric position with the
real world declaration.  Please check.

Thanks.

Send from Lenovo A788t.

Paul Moore <paul@paul-moore.com> wrote:

>On Thursday, November 06, 2014 11:19:06 AM Chen Gang wrote:
>> On 11/6/14 4:43, Paul Moore wrote:
>> > On Tuesday, November 04, 2014 11:09:52 PM Chen Gang wrote:
>> >> audit_file() is related with AUDITSYSCALL, not related with AUDIT, so
>> >> need move dummy one from !AUDIT area to !AUDITSYSCALL area. Or it will
>> >> cause issue if CONFIG_AUDIT with !CONFIG_AUDITSYSCALL.
>> >> 
>> >> The related error (with allmodconfig under tile):
>> >>     CC      fs/open.o
>> >>   
>> >>   fs/open.c: In function 'SYSC_fchmod':
>> >>   fs/open.c:530:3: error: implicit declaration of function 'audit_file'
>> >> 
>> >> [-Werror=implicit-function-declaration] audit_file(f.file);
>> >> 
>> >>      ^
>> >> 
>> >> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> >> ---
>> >> 
>> >>  include/linux/audit.h | 5 ++---
>> >>  1 file changed, 2 insertions(+), 3 deletions(-)
>> > 
>> > What version of the kernel source are you looking at?  I don't see the
>> > audit_file() function anywhere ...
>> 
>> It is for next tree. Sorry for not marking it in subject, originally.
>
>Sorry, I didn't see Al's patch posted to the audit list and it wasn't in the 
>audit next branch so I was a bit confused.
>
>Regardless, it looks fine to me.  While normally I'd pull this into the audit 
>next branch, in this case it is best if Al pulls this into his tree so it goes 
>in with the original audit_file() patch.
>
>If you have to respin this patch I might suggest moving the prototype to after 
>the other audit_inode*() prototypes, e.g. just before audit_core_dumps(), but 
>that is a pretty nit-picky thing.
>
>Acked-by: Paul Moore <paul@paul-moore.com>
>
>> >> diff --git a/include/linux/audit.h b/include/linux/audit.h
>> >> index 295ae1c..7b1d0d1 100644
>> >> --- a/include/linux/audit.h
>> >> +++ b/include/linux/audit.h
>> >> @@ -363,6 +363,8 @@ static inline void audit_inode(struct filename *name,
>> >> 
>> >>  				const struct dentry *dentry,
>> >>  				unsigned int parent)
>> >>  
>> >>  { }
>> >> 
>> >> +static inline void audit_file(struct file *file)
>> >> +{ }
>> >> 
>> >>  static inline void audit_inode_parent_hidden(struct filename *name,
>> >>  
>> >>  				const struct dentry *dentry)
>> >>  
>> >>  { }
>> >> 
>> >> @@ -538,9 +540,6 @@ static inline void audit_log_task_info(struct
>> >> audit_buffer *ab, struct task_struct *tsk)
>> >> 
>> >>  { }
>> >>  #define audit_enabled 0
>> >> 
>> >> -static inline void audit_file(struct file *file)
>> >> -{
>> >> -}
>> >> 
>> >>  #endif /* CONFIG_AUDIT */
>> >>  static inline void audit_log_string(struct audit_buffer *ab, const char
>> >> 
>> >> *buf) {
>
>-- 
>paul moore
>www.paul-moore.com
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
