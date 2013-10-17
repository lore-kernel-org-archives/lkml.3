Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115Ab3JQBVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:21:49 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46297 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761915Ab3JQBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <20131017011101.GA3860@boyd>
References: <1381520956-20282-1-git-send-email-geyslan@gmail.com>
	<20131017011101.GA3860@boyd>
Date: Wed, 16 Oct 2013 22:21:46 -0300
Message-ID: <CAGG-pUQbCMz6GJEOJUPnLA-+dbrUB=E81P9yjvT6EEysdNzSEA@mail.gmail.com>
Subject: Re: [PATCH] ecryptfs: Fix memory leakage in keystore.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Tyler Hicks <tyhicks@canonical.com>:
> On 2013-10-11 16:49:16, Geyslan G. Bem wrote:
>> In 'decrypt_pki_encrypted_session_key' function:
>>
>> Initializes 'payload' pointer and releases it on exit.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>
> Thanks! This one was easy to verify by auditing the code, but I was also
> able to verify the leak with kmemleak.
It's a pleasure.

>
> I've targeted it for stable and pushed it to the eCryptfs next branch.
>
Thank you.

> Tyler
>
>>  fs/ecryptfs/keystore.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
>> index 7d52806..4725a07 100644
>> --- a/fs/ecryptfs/keystore.c
>> +++ b/fs/ecryptfs/keystore.c
>> @@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
>>       struct ecryptfs_msg_ctx *msg_ctx;
>>       struct ecryptfs_message *msg = NULL;
>>       char *auth_tok_sig;
>> -     char *payload;
>> +     char *payload = NULL;
>>       size_t payload_len = 0;
>>       int rc;
>>
>> @@ -1203,6 +1203,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
>>       }
>>  out:
>>       kfree(msg);
>> +     kfree(payload);
>>       return rc;
>>  }
>>
>> --
>> 1.8.4
>>
