Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEGFpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:45:23 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37172 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaEGFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140506165901.GS18016@ZenIV.linux.org.uk>
References: <5368E46B.9050708@samsung.com>
	<20140506165901.GS18016@ZenIV.linux.org.uk>
Date: Wed, 7 May 2014 08:45:19 +0300
Message-ID: <CACE9dm_Wgndgx_tdvZ=P5jY6AGq=utMxNqU+UrYhguj67PKU6Q@mail.gmail.com>
Subject: Re: IMA & truncate
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2014 19:59, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 06, 2014 at 04:32:27PM +0300, Dmitry Kasatkin wrote:
>> Hi,
>>
>> I have discovered one IMA related issue.
>>
>> IMA file hash is re-calculate if needed on file close.
>>
>> It works with ftruncate(fd, length) syscall, because it operates on
>> "opened" file.
>> Recalculation is happening on file close.
>>
>> truncate(path, length) syscall works with path and no file open/close
>> takes place.
>> Recalculation does not happen.
>> IMA denies file access later.
>>
>> It looks like vfs_truncate() should possibly call IMA to recalculate the
>> hash.
>
> Who said that it has permissions to read the file?  Reread truncate(2)
> manpage; it requires the file to be *writable* for caller, but it doesn't
> need it to be readable.

Sorry for repost. Lousy Android gmail client is not able to send with
plain text, even with reply.

This is the same case as for normal file close.
IMA will do file reading for the purpose of calculating a hash, even
file was opened for writing only. File reading is done when the last
writer closes the file and it is protected by mutex. Subsequent file
open is delayed by the mutex.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
