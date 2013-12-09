Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab3LITVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:21:16 -0500
Received: from mail.tpi.com ([74.45.170.26]:51005 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab3LITVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:21:12 -0500
Message-ID: <52A61825.5060104@tpi.com>
Date: Mon, 09 Dec 2013 12:21:09 -0700
From: Tim Gardner <timg@tpi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        Dean Gehnert <deang@tpi.com>
Subject: Re: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count
 check
References: <1386536924-51726-1-git-send-email-timg@tpi.com>	<1386536924-51726-4-git-send-email-timg@tpi.com> <20131209060321.030be558@tlielax.poochiereds.net>
In-Reply-To: <20131209060321.030be558@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 04:03 AM, Jeff Layton wrote:
> On Sun,  8 Dec 2013 14:08:43 -0700
> Tim Gardner <timg@tpi.com> wrote:
> 
>> The reference count on tlink can only be decremented if
>> cifs_sb_tlink(cifs_sb) was used to acquire it. That only
>> happens if open_file==NULL.
>>
>> Cc: Steve French <sfrench@samba.org>
>> Cc: Jeff Layton <jlayton@redhat.com>
>> Cc: Dean Gehnert <deang@tpi.com>
>> Signed-off-by: Tim Gardner <timg@tpi.com>
>> ---
>>
>> V2 - this is a new patch in the V2 series.
>>
>>  fs/cifs/inode.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 3f710c6..e332038 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>>  			CIFSSMBClose(xid, tcon, netfid);
>>  		}
>>  	}
>> -	if (tlink)
>> +	if (!open_file)
>>  		cifs_put_tlink(tlink);
>>  
>>  set_size_out:
> 
> 
> I don't see the bug here...
> 
> The only place tlink gets set to a non-NULL value is where
> cifs_sb_tlink gets called. Am I missing something?
> 

Nope - I think you're correct. For some reason I thought tlink was set
inside the 'if (openfile) {...}' clause. I'll drop this patch from the
V3 series.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
