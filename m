Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaC0QVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:21:46 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39816 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaC0QVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <533446A7.6020003@redhat.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140327004225.GA20247@sergelap> <CALCETrUtRzViEYUNev1JNFZMms56uiw47YZezak0Z0PKgFneQA@mail.gmail.com>
 <533446A7.6020003@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Mar 2014 09:21:22 -0700
Message-ID: <CALCETrXbN1vgTNJB2UGeDvxJ+pwsqO1dOfea5Crs4As1A8dKUg@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: Florian Weimer <fweimer@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 8:41 AM, Florian Weimer <fweimer@redhat.com> wrote:
> On 03/27/2014 02:01 AM, Andy Lutomirski wrote:
>
>> Essentially, it's a performance problem.  knfsd has override_creds,
>> and it can cache struct cred.  But userspace doing the same thing
>> (i.e. impersonating a user) has to do setresuid, setresgid, and
>> setgroups, which kills performance, since it results in something like
>> five RCU callbacks per impersonation round-trip.
>
>
> Do you mean setfsuid instead of setresuid?

No, but I should have given context.  setfsuid sucks, since its return
value is garbage.  It's also pointless nowadays, since setresuid can
be used to sanely change only the effective uid, and doing so should
be secure.

See: http://article.gmane.org/gmane.linux.kernel/1540880

--Andy
