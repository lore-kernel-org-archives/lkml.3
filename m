Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaC0Pll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbaC0Plj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:41:39 -0400
Message-ID: <533446A7.6020003@redhat.com>
Date: Thu, 27 Mar 2014 16:41:27 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
CC: Jim Lieb <jlieb@panasas.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Subject: Re: Thoughts on credential switching
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <20140327004225.GA20247@sergelap> <CALCETrUtRzViEYUNev1JNFZMms56uiw47YZezak0Z0PKgFneQA@mail.gmail.com>
In-Reply-To: <CALCETrUtRzViEYUNev1JNFZMms56uiw47YZezak0Z0PKgFneQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 02:01 AM, Andy Lutomirski wrote:

> Essentially, it's a performance problem.  knfsd has override_creds,
> and it can cache struct cred.  But userspace doing the same thing
> (i.e. impersonating a user) has to do setresuid, setresgid, and
> setgroups, which kills performance, since it results in something like
> five RCU callbacks per impersonation round-trip.

Do you mean setfsuid instead of setresuid?

-- 
Florian Weimer / Red Hat Product Security Team
