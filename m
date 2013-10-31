Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3JaDAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 23:00:44 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45084 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3JaDAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 23:00:43 -0400
References: <1383126294-28793-1-git-send-email-cxie@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com> <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <bbboson@gmail.com>
To: "Luck\, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Madper Xie <cxie@redhat.com>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "ccross\@android.com" <ccross@android.com>,
        "anton\@enomsg.org" <anton@enomsg.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bbboson\@gmail.com" <bbboson@gmail.com>
Subject: Re: [PATCH 0/2] make all stored entries accessible.
In-reply-to: <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
Date: Thu, 31 Oct 2013 11:00:35 +0800
Message-ID: <87d2mm6t64.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tony.luck@intel.com writes:

>> So, do you mean efivars should fix to use the "id" in a proper way?
>
> It would avoid the need for all these tests, and additions to the filename to guarantee
> uniqueness.
>
> Not sure what options efivars has to create a unique, persistent "id" for each
> record.  It's a fundamental part of how ERST works (though the unique ID is just
> based around a timestamp).
>
Okay, maybe there are three options here:
1. combine timestamp, count and part into "id".
   for now, in efi-pstore.c, *id = part. and we could simply change it
   to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.
2. change the id's type. let id become a string.
   so every backend could write anything to id. then it will become a
   part of filename in pstore filesystem. (but we need fix all backends
   since we modified api.)
3. apply the patches I have sent... even if the filename will be ugly
   and gory...
Which one do you prefer?
>> I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
>> it is reasonable for users to make multiple numbers visible to the file name.
>>
>>> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
>
> after I added the "count = 0" initialization the filename gets a tiny bit less
> scary:
>
> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029-0-1383165669
>
> -Tony


-- 
Best,
Madper Xie.
