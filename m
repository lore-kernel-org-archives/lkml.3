Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaAaVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:13:29 -0500
Received: from linuxhacker.ru ([217.76.32.60]:45968 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbaAaVN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:13:27 -0500
X-Greylist: delayed 1850 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 16:13:27 EST
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140131210334.GO10323@ZenIV.linux.org.uk>
Date: Fri, 31 Jan 2014 16:13:19 -0500
Cc: linux-kernel@vger.kernel.org, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru> <20140131210334.GO10323@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2014, at 4:03 PM, Al Viro wrote:
>> diff --git a/fs/namei.c b/fs/namei.c
>> index bcb838e..e620937 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -3931,6 +3931,7 @@ out_dput:
>> 			goto retry;
>> 	}
>> 	if (retry_estale(error, how)) {
>> +		path_put(&old_path);
>> 		how |= LOOKUP_REVAL;
>> 		goto retry;
>> 	}
> Umm...  That obviously can't be right - we have another goto retry
> in the same situation (see in your diff context).  I agree that
> we have a leak there, but you've fixed only a half of it.

Hm, you are right, I did not notice this other one somehow.

So, not to take any guesses, should I convert the other goto retry into
retry_deleg similar in style to what happens in rename and unlink, only
make retry)deleg label before call to the security_path_link?
After the call to the security_path_link?
Or would you prefer to just free old_path in both cases?

Bye,
    Oleg
