Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaJTNnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:43:32 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:40086 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751962AbaJTNnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:43:31 -0400
Message-ID: <54451115.6070908@posteo.de>
Date: Mon, 20 Oct 2014 15:41:41 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lguest: force file->private_data to be NULL on open()
References: <5442F3D0.3070203@posteo.de> <1413678660-29669-1-git-send-email-martink@posteo.de> <1413678660-29669-3-git-send-email-martink@posteo.de>
In-Reply-To: <1413678660-29669-3-git-send-email-martink@posteo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-10-19 02:31, schrieb Martin Kepplinger:
> if we depend on private_data being NULL in write() before initialize()
> make sure it is NULL after open().
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> 
> I'm not completely sure if this patch is needed and am still investigating.
> What do you think? open() could be called by the user I guess. Does
> lguest_user.c depend on private_data being NULL on a first write()?
> 
> 

Could it be that this patch is not needed indeed or did I ask not clear
enough here and caused a misunderstanding:


> Martin Kepplinger <martink@posteo.de> writes:
>> hi
>>
>> Just a question for understanding: open() is not implemented in
>> lguest_user.c's miscdevice. The miscdevice core, in this case, does
>> _not_ set file->private_data on a user's open() call. Is open() called
>> by the user here? and do you here _depend_ on file->private_data being
>> NULL after open()? (could you even?)
>>
>> Would the following force to NULL be necessary if the miscdevice core
>> _would_ set private_data?
>
> Hi Martin!
>
>         Yes, the private_data is NULL on a new file.  See
> get_empty_filp in fs/file_table.c, which does kmem_cache_zalloc
> (zeroing all the contents).
>
> So this isn't necessary here.
>
> Thanks!
> Rusty.

