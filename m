Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3CLXhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:37:36 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33274 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3CLXhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:37:33 -0400
MIME-Version: 1.0
In-Reply-To: <1363078947.1344.1.camel@tucsk.piliscsaba.szeredi.hu>
References: <1363042456-8895-1-git-send-email-arve@android.com>
	<1363078947.1344.1.camel@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 12 Mar 2013 16:37:32 -0700
Message-ID: <CAMP5XgdjHrjSAvKVzibOT0YyAYfncCsDqkMMCuBHyyWWMpnXfQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: Fix build after change to synchronize with library
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 2:02 AM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> On Mon, 2013-03-11 at 15:54 -0700, Arve Hjønnevåg wrote:
>> __linux__ is not always defined so check __KERNEL__ as well.
>>
>> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>> ---
>>  include/uapi/linux/fuse.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>> index 4c43b44..fc5d400 100644
>> --- a/include/uapi/linux/fuse.h
>> +++ b/include/uapi/linux/fuse.h
>> @@ -95,7 +95,7 @@
>>  #ifndef _LINUX_FUSE_H
>>  #define _LINUX_FUSE_H
>>
>> -#ifdef __linux__
>> +#if defined(__KERNEL__) || defined(__linux__)
>
> Or how about just
>
> #ifdef __KERNEL__
>

I don't think that will give you the same behavior when compiling
user-space code.

-- 
Arve Hjønnevåg
