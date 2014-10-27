Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaJ0GhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:37:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ0GhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:37:05 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-c7-544de80f9bc9
Date: Mon, 27 Oct 2014 12:24:13 +0530
From: Rohit <rohit.kr@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: PINTU KUMAR <pintu_agarwal@yahoo.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        "iqbal.ams@samsung.com" <iqbal.ams@samsung.com>,
        "ed.savinay@samsung.com" <ed.savinay@samsung.com>,
        "me.rohit@live.com" <me.rohit@live.com>
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
Message-id: <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com>
In-reply-to: <544D94C1.8010402@schaufler-ca.com>
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
 <543FF121.7000502@schaufler-ca.com>
 <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
 <544129FD.8060902@schaufler-ca.com>
 <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com>
 <544153D1.50304@schaufler-ca.com> <544D94C1.8010402@schaufler-ca.com>
Organization: Samsung
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkVpf/hW+IwcPbUhZz1q9hs7i37Reb
	xctDmhaLdi9gspj9axKTRd/jIIvLu+awWXzoecRmcf2evUXf98PsFt/e3ma3OH/hHLvFlL67
	jA68Htd2R3qcmPGbxaPjVgOrx8ent1g8+rasYvQ4un8Rm8fnTXIes2YdZgrgiOKySUnNySxL
	LdK3S+DKOLrnHVPBDtWKzc9msTQwrpXrYuTkkBAwkZg9fwUjhC0mceHeerYuRi4OIYGljBKH
	Pn8HcjjAihb9zACpERKYziix/UUehN3LJHFzBguIzSKgKnGifSkriM0moCTx/9VcNhBbREBH
	Yt+e5+wgM5kFfrFI9F69DtYgLBAl0bNwOdhiXgEniY3nX4I1cwoYSCy8vp0d4ogLTBI/m9az
	gyT4BUQlDi/czgxxqY3E6p3rmCGaBSV+TL4HNpRZQEti87YmVghbXmLzmrfMIIMkBGZySCxd
	s4QV4lQBiW+TD7FAfCYrsekA1ExJiYMrbrBMYBSfhWTsLCRjZyEZu4CReRWjaGpBckFxUnqR
	iV5xYm5xaV66XnJ+7iZGYISf/vdswg7GewesDzEKcDAq8fBOKPYNEWJNLCuuzD3EaAp0xURm
	KdHkfGAaySuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A2NnM//6wy1MRytvMxRfdb99q3TuMoGk/7Zfsi9/ZF+in1Cn95NjI8/2pLJF2Xb+TObz/0hF
	bFf7tWnetHrZpo2nGIKF8pLKwlmWrzqi+uKD2swnK6Nr5E7XPbJcK3Yqm2c+x7QNXXPmLi3/
	9+aV3bLy+gKtVieXJpMmzjvak84/1dzdX7CsJlCJpTgj0VCLuag4EQDWwSoa6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV3+F74hBguXCFrMWb+GzeLetl9s
	Fi8PaVos2r2AyWL2r0lMFn2Pgywu75rDZvGh5xGbxfV79hZ93w+zW3x7e5vd4vyFc+wWU/ru
	MjrwelzbHelxYsZvFo+OWw2sHh+f3mLx6NuyitHj6P5FbB6fN8l5zJp1mCmAI6qB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bRPe+YCnaoVmx+NoulgXGtXBcjB4eEgInE
	op8ZXYycQKaYxIV769lAbCGB6YwS21/kQdi9TBI3Z7CA2CwCqhIn2peygthsAkoS/1/NBasX
	EdCR2LfnOXsXIxcHs8AvFoneq9fBGoQFoiR6Fi5nBLF5BZwkNp5/CdbMKWAgsfD6drAGIYEL
	TBI/m9azgyT4BUQlDi/czgxxkY3E6p3rmCGaBSV+TL4HNpRZQEti87YmVghbXmLzmrfMExgF
	ZyEpm4WkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPHM6kdjCsbLA4xCnAw
	KvHwWhT6hgixJpYVV+YeYpTgYFYS4f14HyjEm5JYWZValB9fVJqTWnyI0RQYNhOZpUST84Gp
	La8k3tDYxNzU2NTSxMLEzFJJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA+ORuXrLj9xjPOrw
	wVl4E8+X6Aezdxqsjfzfvu/EMy5nmbaZ87fb39oTWXzh0Iy+ped1zB/OtAhf/1FPcB/bk6gj
	53rOzb6to/73/OGc5OXVPrkNU9Tqbi2ST/UNlX8zVTfLMyFCaprk7P+zD+lNU+FMehP1kz1o
	FXvTF64Tt1RDpfnjjWNVf3YpsRRnJBpqMRcVJwIA+xtuuzUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014 17:41:37 -0700
Casey Schaufler <casey@schaufler-ca.com> wrote:

> On 10/17/2014 10:37 AM, Casey Schaufler wrote:
> > On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
> >> Hi,
> >>
> >>
> >>> ________________________________
> >>> From: Casey Schaufler <casey@schaufler-ca.com>
> >>> To: Rohit <rohit.kr@samsung.com> 
> >>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com;
> >>> serge@hallyn.com; linux-security-module@vger.kernel.org;
> >>> linux-kernel@vger.kernel.org; cpgs@samsung.com;
> >>> pintu.k@samsung.com; vishnu.ps@samsung.com;
> >>> iqbal.ams@samsung.com; ed.savinay@samsung.com; me.rohit@live.com;
> >>> pintu_agarwal@yahoo.com; Casey Schaufler <casey@schaufler-ca.com>
> >>> Sent: Friday, 17 October 2014 8:08 PM Subject: Re: [PATCH v2]
> >>> Security: smack: replace kzalloc with kmem_cache for inode_smack
> >>>
> >>>
> >>> On 10/17/2014 4:42 AM, Rohit wrote:
> >>>> On Thu, 16 Oct 2014 09:24:01 -0700
> >>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>
> >>>>> On 10/15/2014 5:10 AM, Rohit wrote:
> >>>>>> The patch use kmem_cache to allocate/free inode_smack since
> >>>>>> they are alloced in high volumes making it a perfect case for
> >>>>>> kmem_cache.
> >>>>>>
> >>>>>> As per analysis, 24 bytes of memory is wasted per allocation
> >>>>>> due to internal fragmentation. With kmem_cache, this can be
> >>>>>> avoided.
> >>>>> What impact does this have on performance? I am much more
> >>>>> concerned with speed than with small amount of memory.
> >>>>>
> >>>> I think there should not be any performance problem as such.
> >>>> However, please let me know how to check the performance in this
> >>>> case.
> >>> Any inode intensive benchmark would suffice. Even the classic
> >>> kernel build would do.
> >>>
> >>>> As far as i know, kzalloc first finds the kmalloc_index
> >>>> corresponding to the size to get the kmem_cache_object and then
> >>>> calls kmem_cache_alloc with the kmalloc_index(kmem_cache
> >>>> object). Here, we create kmem_cache object specific for
> >>>> inode_smack and directly calls kmem_cache_alloc() which should
> >>>> give better performance as compared to kzalloc.
> >>> That would be my guess as well, but performance is tricky.
> >>> Sometimes things that "obviously" make performance better make it
> >>> worse. There can be unanticipated side effects.
> >>>
> >>>
> >>>> Please let me know your comments.
> >>> If you can run any sort of test that demonstrates this change
> >>> does not have performance impact, I'm fine with it. Smack is being
> >>> used in small devices, and both memory use and performance are
> >>> critical to the success of these devices. Of the two, performance
> >>> is currently more of an issue.
> >>>
> >> SMACK is used heavily in Tizen. We verified these changes for one
> >> of Tizen project. During boot time we observed that this object is
> >> used heavily, as identified by kmalloc-accounting. After replacing
> >> this we did not observe any difference in boot time. Also there
> >> was no side-effects seen so far. If you know of any other tests,
> >> please let us know. We will also try to gather some performance
> >> stats and present here.
> > We need to be somewhat more precise than "did not observe any
> > difference in boot time". The ideal benchmark would perform lots
> > of changes to the filesystem without doing lots of IO. One process
> > that matches that profile fairly well is a kernel make. I would be
> > satisfied with something as crude as using time(1) on a small (5?)
> > number of clean kernel makes each with and without the patch on the
> > running kernel. At the level of accuracy you usually get from
> > time(1) you won't find trivial differences, but if the change is a
> > big problem (or a big win) we'll know.
> 
> I have not seen anything indicating that the requested performance
> measurements have been done. I have no intention of accepting this
> without assurance that performance has not been damaged. I request
> that no one else carry this forward, either. The performance impact
> of security facilities comes under too much scrutiny to ignore it.
> 
> > ... 
> 
Sorry for the delay as I was on holiday for last week.
Will verify the performance impact as per your suggestion.
We verified it only on Tizen based ARM board, so building kernel on it
is not possible.
I found http://elinux.org/images/0/06/Buzov-SMACK.pdf (slides - 35-37)
for performance verification of smack. It checks performance of file
creation and copy in tmpfs. 
Please let me know whether the procedure mentioned in the above
mentioned slide is fine, else please suggest some other way to check
performance on the target board.


Regards,
Rohit

