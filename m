Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3EZSXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 14:23:07 -0400
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:43870 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754818Ab3EZSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 14:23:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kgO4dl4VM1k36Nto3ey5Tu1NNXTE3mvxsStKema7sBCc2R3
 l.2AV9kNNNkhsnhvTWiF6ugxtMs.Se0.TzcxtPn2b3ijI1t1Ycmh3bmiMcFy
 qZw3GZXzE9v.lCp_iUfybFYj09je634AjJkBmUa.ed66z1cwaBZ6Sv6PQYnU
 aCTvuaLp2vtiSzC5_qJDSs5r1ZTvvoJEAN9ZmuMDt5OGoft19BmcInNUduwp
 h_HpIwPVidlxdu4NpcQI6oYfHPBONpK5hK8FkRCJ644YzKXB7qej9G.usbI2
 7LQAL2E4Xo40ZO2hSeYP9zNSa588qmFbyYA7eK_TT7dxZ2vd674gFQy9.xja
 eqsGFm_KehmPky_G9bsl.e11kn5UHTtCPx7XgtgzRhwE3IEhECNnTtZUcIgc
 PJLLDefToeO17SHfHcDVXG.urnrvLiw4t_os6QNQu0OmvVhoObUUnFOw1Mui
 ynrs6j8vPIYxh4QgeiET_TeyyJ.8v09XYA7P8X82v6EJTyxCm8baAPGchezF
 gVl.szAzSjiqVCy6mSw8XZxypgBheYm0OcIKo7XBhprbo8.LU3Ja_PjPsswX
 MjQWJSXMvrZc-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 26 May 2013 11:23:02 -0700 PDT
Message-ID: <51A25305.90101@schaufler-ca.com>
Date: Sun, 26 May 2013 11:23:01 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Stupid VFS name lookup interface..
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com> <20130526120251.GA32729@thunk.org>
In-Reply-To: <20130526120251.GA32729@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2013 5:02 AM, Theodore Ts'o wrote:
> On Sat, May 25, 2013 at 11:33:46AM -0700, Casey Schaufler wrote:
>> Now I'll put on my Smack maintainer hat. Performance improvement is
>> always welcome, but I would rather see attention to performance of
>> the LSM architecture than SELinux specific hacks. The LSM blob
>> pointer scheme is there so that you (Linus) don't have to see the
>> dreadful things that we security people are doing. Is it time to
>> get past that level of disassociation? Or, and I really hate asking
>> this, have you fallen into the SELinux camp?
> What part of the LSM architecture are you proposing be optimized?

Secids are an inherent performance issue.

This thread is all about a performance problem with
the security blob pointer scheme. I don't know what
would be better and general, but I'm willing to learn.


> The
> LSM layer is pretty thin, partially because the various different
> security approaches don't agree with each other on fairly fundamental
> issues.  What sort of optimization opportunities you are suggesting?
> Are there changes that can be made that all of the major security LSM
> maintainers would actually agree with?

As you point out, the various existing LSMs use a variety of
mechanisms to perform their access checks. A big part of what
I see as the "problem" is that the LSM hooks grew organically,
at a time when there was exactly one project being funded.
By the time other LSMs came in to the mainstream we had a
collection of hooks, not an architecture. The LSM architecture
has not been seriously revisited since.

Can we come to agreement? I don't know. I expect so.

>
> I've been re-reading the thread on LKML which was spawned when SMACK
> was proposed for upstream inclusion:
>
>     http://thread.gmane.org/gmane.linux.kernel/585903/focus=586412
>
> Have any of the arguments over the proper security models changed over
> or have gotten resolved over the past six years, while I haven't been
> looking?

I believe that Yama points to a serious change in the way
"operating systems" are being developed. The desktop is not
the sweet spot for Linux development, nor is the enterprise
server. Six years ago the Bell & LaPadula subject/object models
still made sense. Today, we're looking at applications, services
and resources. We don't have LSMs that support those* natively.
We are going to have new LSMs, and soon, if Linux is going to
remain relevant.

---
* SEAndriod is trying. We'll see where that goes.


>
> 						- Ted
>

