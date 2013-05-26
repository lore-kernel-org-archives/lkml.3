Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3EZR77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:59:59 -0400
Received: from nm14-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.15]:37791
	"EHLO nm14-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab3EZR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:59:57 -0400
X-Yahoo-Newman-Id: 757210.91847.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NLTf0UUVM1mGwb91ojBcEEshbmSjorlUfDdY.7kxJnXM9mZ
 Lk.H4V5zPosFMrxPXhHMVyWudoZ_R_WdCQ_L_qxJB2lEjMur8wMg0Bu0_.vq
 BcE1QPxAE.pBE5pKgRhwkN4ujrHo7p8lOUQXZcnLmFUZxj1Wd03CBZ1uY3RL
 iknri4yzeJ1xE2GngkMdtQ6TAfGbzYgQKx42Zrc_O8IK1lm2Y3y6DpABiq8x
 zxuSCKlOY_xdHntjYWxg.t8bysbPZIfIC1INNO2VQe_G_AXT0QAWh7vgZgwA
 ujlFqOtu0sRHi4g_cmSqmSKNDn3GHaxnFPwgtTEmUDUdYWZ_Sc7UojCcpO0E
 qVDEe6of1fiCMWEmw4ZTFKh.wPBOAOn.gI_WTrGv10wLD.IEmyRUHZlNctyg
 HRZEFNFv7mDdOOmxTxG1fO34ZZf4UFNde3Em41eUQUkJ1g009yUU5d2XwXkp
 0MTX6UhuBr5.zdg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 26 May 2013 10:59:56 -0700 PDT
Message-ID: <51A24D9B.50104@schaufler-ca.com>
Date: Sun, 26 May 2013 10:59:55 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Stupid VFS name lookup interface..
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com> <CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com> <alpine.LRH.2.02.1305261503510.7712@tundra.namei.org> <CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
In-Reply-To: <CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2013 10:19 PM, Linus Torvalds wrote:
> On Sat, May 25, 2013 at 10:04 PM, James Morris <jmorris@namei.org> wrote:
>> On Sat, 25 May 2013, Linus Torvalds wrote:
>>
>>> But I haven't even looked at what non-selinux setups do to
>>> performance. Last time I tried Ubuntu (they still use apparmor, no?),
>>> "make modules_install ; make install" didn't work for the kernel, and
>>> if the Ubuntu people don't want to support kernel engineers, I
>>> certainly am not going to bother with them. Who uses smack?
>> Tizen, perhaps a few others.
> Btw, it really would be good if security people started realizing that
> performance matters. It's annoying to see the security lookups cause
> 50% performance degradations on pathname lookup (and no, I'm not
> exaggerating, that's literally what it was before we fixed it - and
> no, by "we" I don't mean security people).

I think that we have a pretty good idea that performance matters.
I have never, not even once, tried to introduce a "security" feature
that was not subject to an objection based on its performance impact.
We are also extremely tuned into the desire that when our security
features are not present the impact of their potential availability
has to be zero.

The whole secid philosophy comes out of the need to keep security out
of other people's way. It has performance impact. Sure, SELinux
hashes lookups, but a blob pointer gets you right where you want to be.
When we are constrained in unnatural ways there are going to be
consequences. Performance is one. Code complexity is another.

One need look no further than the recent discussions regarding Paul
Moore's suggested changes to sk_buff to see just how seriously
performance considerations impact security development. Because the
security data in the sk_buff is limited to a u32 instead of a blob
pointer labeled networking performance is seriously worse than
unlabeled. Paul has gone to heroic lengths to come up with a change
that meets all of the performance criteria, and has still been
rejected. Not because the stated issues haven't been addressed, but
because someone else might have changes that "need those cache lines"
in the future.

Two of the recent Smack changes have been performance improvements.
Smack is currently under serious scrutiny for performance as it is
heading into small machines.

I'm not saying we can't do better, or that we (at least I) don't
appreciate any help we can get. We are, however, bombarded with
concern over the performance impact of what we're up to. All too
often it's not constructive criticism. Sometimes it is downright
hostile.

>
> There's a really simple benchmark that is actually fairly relevant:
> build a reasonable kernel ("make localmodconfig" or similar - not the
> normal distro kernel that has everything enabled) without debugging or
> other crud enabled, run that kernel, and then re-build the fully built
> kernel to make sure it's all in the disk cache. Then, when you don't
> need any IO, and don't need to recompile anything, do a "make -j".
>
> Assuming you have a reasonably modern desktop machine, it should take
> something like 5-10 seconds, of which almost everything is just "make"
> doing lots of stat() calls to see that everything is fully built. If
> it takes any longer, you're doing something wrong.
>
> Once you are at that point, just do "perf record -f -e cycles:pp make
> -j" and then "perf report" on the thing.
>
> (The "-e cycles:pp" is not necessary for the rough information, but it
> helps if you then want to go and annotate the assembler to see where
> the costs come from).
>
> If you see security functions at the top, you know that the security
> routines take more time than the real work the kernel is doing, and
> should realize that that would be a problem.
>
> Right now (zooming into the kernel only - ignoring the fact that make
> really spends a fair amount of time in user space) I get
>
>   9.79%      make  [k] __d_lookup_rcu
>   5.48%      make  [k] link_path_walk
>   2.94%      make  [k] avc_has_perm_noaudit
>   2.47%      make  [k] selinux_inode_permission
>   2.25%      make  [k] path_lookupat
>   1.89%      make  [k] generic_fillattr
>   1.50%      make  [k] lookup_fast
>   1.27%      make  [k] copy_user_generic_string
>   1.17%      make  [k] generic_permission
>   1.15%      make  [k] dput
>   1.12%      make  [k] inode_has_perm.constprop.58
>   1.11%      make  [k] __inode_permission
>   1.08%      make  [k] kmem_cache_alloc
>   ...
>
> so the permission checking is certainly quite noticeable, but it's by
> no means dominant. This is with both of the patches I've posted, but
> the numbers weren't all that different before (inode_has_perm and
> selinux_inode_permission used to be higher up in the list, now
> avc_has_perm_noaudit is the top selinux cost - which actually makes
> some amount of sense).
>
> So it's easy to have a fairly real-world performance profile that
> shows path lookup costs on a real test.
>
>                   Linus
>

