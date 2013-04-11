Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937252Ab3DKBEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:04:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8824 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936111Ab3DKBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:04:18 -0400
X-Spam-Score: -100.8
Message-ID: <51660BEC.1080901@asianux.com>
Date: Thu, 11 Apr 2013 09:03:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] kernel: audit: beautify code, for extern function, better
 to check its parameters by itself
References: <5161347B.8090604@asianux.com> <1216477171.11118824.1365615063121.JavaMail.root@redhat.com>
In-Reply-To: <1216477171.11118824.1365615063121.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 01:31, Eric Paris wrote:
> ----- Original Message -----
>> > 
>> >   __audit_socketcall is an extern function.
>> >   better to check its parameters by itself.
>> > 
>> >     also can return error code, when fail (find invalid parameters).
>> >     also use macro instead of real hard code number
>> >     also give related comments for it.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  include/linux/audit.h |   12 ++++++++----
>> >  kernel/auditsc.c      |    9 ++++++---
>> >  net/socket.c          |    6 ++++--
>> >  3 files changed, 18 insertions(+), 9 deletions(-)
>> > 
>> > diff --git a/include/linux/audit.h b/include/linux/audit.h
>> > @@ -354,7 +358,7 @@ static inline int audit_bprm(struct linux_binprm *bprm)
>> >  {
>> >  	return 0;
>> >  }
>> > -static inline void audit_socketcall(int nargs, unsigned long *args)
>> > +static inline int audit_socketcall(int nargs, unsigned long *args)
>> >  { }
>> >  static inline void audit_fd_pair(int fd1, int fd2)
>> >  { }
> This now returns a value but you forgot to return a value.  Thus this would not even build...   I fixed it up myself.

  thank you very much.


  :-)


-- 
Chen Gang

Asianux Corporation
