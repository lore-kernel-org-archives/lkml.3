Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3AWF7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:59:25 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:59993 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3AWF7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130122203603.1bd26363@corrin.poochiereds.net>
References: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
	<20130122203603.1bd26363@corrin.poochiereds.net>
Date: Tue, 22 Jan 2013 23:59:23 -0600
Message-ID: <CAH2r5mtSTOWc7Caf3UA=SGY3_PoR-xFOyXHd4OiYZSGXa5W_YQ@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Cong Ding <dinggnu@gmail.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Tue, Jan 22, 2013 at 7:36 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Tue, 22 Jan 2013 19:20:58 -0500
> Cong Ding <dinggnu@gmail.com> wrote:
>
>> When it goes to error through line 144, the memory allocated to *devname is
>> not freed, and the caller doesn't free it either in line 250. So we free the
>> memroy of *devname in function cifs_compose_mount_options() when it goes to
>> error.
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> ---
>>  fs/cifs/cifs_dfs_ref.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
>> index ce5cbd7..210fce2 100644
>> --- a/fs/cifs/cifs_dfs_ref.c
>> +++ b/fs/cifs/cifs_dfs_ref.c
>> @@ -226,6 +226,8 @@ compose_mount_options_out:
>>  compose_mount_options_err:
>>       kfree(mountdata);
>>       mountdata = ERR_PTR(rc);
>> +     kfree(*devname);
>> +     *devname = NULL;
>>       goto compose_mount_options_out;
>>  }
>>
>
> Nice catch. Looks correct to me. Should this also go to stable?
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>



-- 
Thanks,

Steve
