Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaFPWIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:08:19 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59185 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFPWIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <539EF5FD.5000307@samba.org>
References: <1402394606-7910-1-git-send-email-bb@sernet.de> <539EF5FD.5000307@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Jun 2014 17:07:56 -0500
Message-ID: <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Baumbach?= <bb@sernet.de>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although I have merged this into cifs-2.6.git for-next, in my testing
I am also seeing this fail with vers=3.0 (and probably 2.0 and 2.1) so
I would like to fix that too (and mfsymlinks may be at least as
important there)

On Mon, Jun 16, 2014 at 8:49 AM, Stefan (metze) Metzmacher
<metze@samba.org> wrote:
> Hi Steve,
>
> any comments on this? How can we get this fixed upstream?
>
> Thanks!
> metze
>
> Am 10.06.2014 12:03, schrieb Björn Baumbach:
>> commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
>> ("CIFS: Cleanup cifs open codepath")
>> changed disposition to FILE_OPEN.
>>
>> Signed-off-by: Björn Baumbach <bb@sernet.de>
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> Reviewed-by: Stefan Metzmacher <metze@samba.org>
>> Cc: <stable@vger.kernel.org> # v3.14+
>> Cc: Pavel Shilovsky <piastry@etersoft.ru>
>> Cc: Steve French <sfrench@samba.org>
>> ---
>>  fs/cifs/link.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>> index 264ece7..68559fd 100644
>> --- a/fs/cifs/link.c
>> +++ b/fs/cifs/link.c
>> @@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>>       oparms.cifs_sb = cifs_sb;
>>       oparms.desired_access = GENERIC_WRITE;
>>       oparms.create_options = create_options;
>> -     oparms.disposition = FILE_OPEN;
>> +     oparms.disposition = FILE_CREATE;
>>       oparms.path = path;
>>       oparms.fid = &fid;
>>       oparms.reconnect = false;
>>
>



-- 
Thanks,

Steve
