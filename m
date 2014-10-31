Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbaJaDqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:46:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaJaDqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:46:05 -0400
X-AuditID: cbfee68e-f79b46d000002b74-ae-545305fb13cc
Date: Fri, 31 Oct 2014 09:33:25 +0530
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
Message-id: <20141031093325.64808c2d@rohitk-ubuntu.sisodomain.com>
In-reply-to: <545103C5.3050509@schaufler-ca.com>
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
 <543FF121.7000502@schaufler-ca.com>
 <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
 <544129FD.8060902@schaufler-ca.com>
 <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com>
 <544153D1.50304@schaufler-ca.com> <544D94C1.8010402@schaufler-ca.com>
 <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com>
 <544E71F8.60301@schaufler-ca.com>
 <20141029144134.46e16fb1@rohitk-ubuntu.sisodomain.com>
 <545103C5.3050509@schaufler-ca.com>
Organization: Samsung
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkSvc3a3CIwdafXBZz1q9hs7i37Reb
	xctDmhaLdi9gspj9axKTRd/jIIvLu+awWXzoecRmcf2evUXf98PsFt/e3ma3OH/hHLvFlL67
	jA68Htd2R3qcmPGbxaPjVgOrx8ent1g8+rasYvQ4un8Rm8fnTXIes2YdZgrgiOKySUnNySxL
	LdK3S+DKWPrvBlvBPauKDc+3sTcw7tHtYuTkkBAwkdi8fwIbhC0mceHeeiCbi0NIYCmjxJqZ
	P9lhig5uP88IkVjEKLHrTyM7hNPLJLHu1SKwKhYBVYnV2z8zgthsAkoS/1/NBRsrIqAjsW/P
	c7AGZoFfLBK9V6+zgCSEBaIkehYuB2vgFXCSWPdjDlicU8BAorHnKQvEhh4WiTt7PzKBJPgF
	RCUOL9zODHGTjcTqneuYIZoFJX5MvgfWzCygJbF5WxMrhC0vsXnNW2aQQRICUzkkNre3sEKc
	KiDxbfIhoAYOoISsxKYDUDMlJQ6uuMEygVF8FpKxs5CMnYVk7AJG5lWMoqkFyQXFSelFRnrF
	ibnFpXnpesn5uZsYgXF++t+zvh2MNw9YH2IU4GBU4uH9cTIoRIg1say4MvcQoynQFROZpUST
	84HJJK8k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbi
	WZnrHryzfrbAKtVTwOt+Rs1J0fd/zp9294n/ffagyozc6K8z29Y27Gx8fuvCdIbpTBMiqlzl
	K1a1P9L2+fLW7vvlUwYG693WC3L5BD4/2lF2IXvl5yvPNqz/unw7833OTKtZSRo3DN/vP9ql
	rVGuHvp+f6/xPObnG08u1utQmznzXfMiP/aFSizFGYmGWsxFxYkAF1CDfu4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd3frMEhBjvFLeasX8NmcW/bLzaL
	l4c0LRbtXsBkMfvXJCaLvsdBFpd3zWGz+NDziM3i+j17i77vh9ktvr29zW5x/sI5dospfXcZ
	HXg9ru2O9Dgx4zeLR8etBlaPj09vsXj0bVnF6HF0/yI2j8+b5DxmzTrMFMAR1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0r5JCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+m/G2wF96wqNjzfxt7AuEe3i5GTQ0LAROLg
	9vOMELaYxIV769m6GLk4hAQWMUrs+tPIDuH0Mkmse7WIHaSKRUBVYvX2z2AdbAJKEv9fzWUD
	sUUEdCT27XkO1sAs8ItFovfqdRaQhLBAlETPwuVgDbwCThLrfswBi3MKGEg09jxlgdjQwyJx
	Z+9HJpAEv4CoxOGF25khbrKRWL1zHTNEs6DEj8n3wJqZBbQkNm9rYoWw5SU2r3nLPIFRcBaS
	sllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziFPJPewbiqweIQowAHoxIP
	74LjQSFCrIllxZW5hxglOJiVRHgnvQUK8aYkVlalFuXHF5XmpBYfYjQFhs1EZinR5Hxgessr
	iTc0NjE3NTa1NLEwMbNUEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cDIPt382KvFHya6cSev
	fvNr2xmnv3P3pPO4Jfj/+/hcJTi2+diWSSvipVV2vTpy5I4gu2usxQU9rYrNOd0NOsVtP+QD
	ZAI2nQzLX+NRIvV9x5q5qh/987NmsEc8v/Ow6+mnLfua9HmeOHzLOu5w2EkhL+x70C3nJ8Ky
	WenXba5ZbGKYc8D1uAyfEktxRqKhFnNRcSIA152stzcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 08:12:05 -0700
Casey Schaufler <casey@schaufler-ca.com> wrote:

> On 10/29/2014 2:11 AM, Rohit wrote:
> > On Mon, 27 Oct 2014 09:25:28 -0700
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> >
> >> On 10/26/2014 11:54 PM, Rohit wrote:
> >>> On Sun, 26 Oct 2014 17:41:37 -0700
> >>> Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>
> >>>> On 10/17/2014 10:37 AM, Casey Schaufler wrote:
> >>>>> On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>>
> >>>>>>> ________________________________
> >>>>>>> From: Casey Schaufler <casey@schaufler-ca.com>
> >>>>>>> To: Rohit <rohit.kr@samsung.com> 
> >>>>>>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com;
> >>>>>>> serge@hallyn.com; linux-security-module@vger.kernel.org;
> >>>>>>> linux-kernel@vger.kernel.org; cpgs@samsung.com;
> >>>>>>> pintu.k@samsung.com; vishnu.ps@samsung.com;
> >>>>>>> iqbal.ams@samsung.com; ed.savinay@samsung.com;
> >>>>>>> me.rohit@live.com; pintu_agarwal@yahoo.com; Casey Schaufler
> >>>>>>> <casey@schaufler-ca.com> Sent: Friday, 17 October 2014 8:08 PM
> >>>>>>> Subject: Re: [PATCH v2] Security: smack: replace kzalloc with
> >>>>>>> kmem_cache for inode_smack
> >>>>>>>
> >>>>>>>
> >>>>>>> On 10/17/2014 4:42 AM, Rohit wrote:
> >>>>>>>> On Thu, 16 Oct 2014 09:24:01 -0700
> >>>>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>>>>>
> >>>>>>>>> On 10/15/2014 5:10 AM, Rohit wrote:
> >>>>>>>>>> The patch use kmem_cache to allocate/free inode_smack since
> >>>>>>>>>> they are alloced in high volumes making it a perfect case
> >>>>>>>>>> for kmem_cache.
> >>>>>>>>>>
> >>>>>>>>>> As per analysis, 24 bytes of memory is wasted per
> >>>>>>>>>> allocation due to internal fragmentation. With kmem_cache,
> >>>>>>>>>> this can be avoided.
> >>>>>>>>> What impact does this have on performance? I am much more
> >>>>>>>>> concerned with speed than with small amount of memory.
> >>>>>>>>>
> >>>>>>>> I think there should not be any performance problem as such.
> >>>>>>>> However, please let me know how to check the performance in
> >>>>>>>> this case.
> >>>>>>> Any inode intensive benchmark would suffice. Even the classic
> >>>>>>> kernel build would do.
> >>>>>>>
> >>>>>>>> As far as i know, kzalloc first finds the kmalloc_index
> >>>>>>>> corresponding to the size to get the kmem_cache_object and
> >>>>>>>> then calls kmem_cache_alloc with the kmalloc_index(kmem_cache
> >>>>>>>> object). Here, we create kmem_cache object specific for
> >>>>>>>> inode_smack and directly calls kmem_cache_alloc() which
> >>>>>>>> should give better performance as compared to kzalloc.
> >>>>>>> That would be my guess as well, but performance is tricky.
> >>>>>>> Sometimes things that "obviously" make performance better make
> >>>>>>> it worse. There can be unanticipated side effects.
> >>>>>>>
> >>>>>>>
> >>>>>>>> Please let me know your comments.
> >>>>>>> If you can run any sort of test that demonstrates this change
> >>>>>>> does not have performance impact, I'm fine with it. Smack is
> >>>>>>> being used in small devices, and both memory use and
> >>>>>>> performance are critical to the success of these devices. Of
> >>>>>>> the two, performance is currently more of an issue.
> >>>>>>>
> >>>>>> SMACK is used heavily in Tizen. We verified these changes for
> >>>>>> one of Tizen project. During boot time we observed that this
> >>>>>> object is used heavily, as identified by kmalloc-accounting.
> >>>>>> After replacing this we did not observe any difference in boot
> >>>>>> time. Also there was no side-effects seen so far. If you know
> >>>>>> of any other tests, please let us know. We will also try to
> >>>>>> gather some performance stats and present here.
> >>>>> We need to be somewhat more precise than "did not observe any
> >>>>> difference in boot time". The ideal benchmark would perform lots
> >>>>> of changes to the filesystem without doing lots of IO. One
> >>>>> process that matches that profile fairly well is a kernel make.
> >>>>> I would be satisfied with something as crude as using time(1)
> >>>>> on a small (5?) number of clean kernel makes each with and
> >>>>> without the patch on the running kernel. At the level of
> >>>>> accuracy you usually get from time(1) you won't find trivial
> >>>>> differences, but if the change is a big problem (or a big win)
> >>>>> we'll know.
> >>>> I have not seen anything indicating that the requested
> >>>> performance measurements have been done. I have no intention of
> >>>> accepting this without assurance that performance has not been
> >>>> damaged. I request that no one else carry this forward, either.
> >>>> The performance impact of security facilities comes under too
> >>>> much scrutiny to ignore it.
> >>>>
> >>>>> ... 
> >>> Sorry for the delay as I was on holiday for last week.
> >>> Will verify the performance impact as per your suggestion.
> >>> We verified it only on Tizen based ARM board, so building kernel
> >>> on it is not possible.
> >>> I found http://elinux.org/images/0/06/Buzov-SMACK.pdf (slides -
> >>> 35-37) for performance verification of smack. It checks
> >>> performance of file creation and copy in tmpfs. 
> >>> Please let me know whether the procedure mentioned in the above
> >>> mentioned slide is fine, else please suggest some other way to
> >>> check performance on the target board.
> >> The technique outlined by Buzov should provide adequate evidence.
> > We carried out file creation of 0, 1k and 4k size for 1024 files
> > and measured the time taken. It was done for 5 iterations for each
> > case with kzalloc and kmem_cache on a board with 512MB RAM and 1.2
> > GHz dual core arm processor. The average latency is as follows :
> > File size   with kzalloc(in ms)   with kmem_cache(in ms)
> > %change 0           10925.6               10528.8
> > -3.63 1k           11909.8               11617.6
> > -2.45 4k           11632.2               11873.2
> > +2.07
> >
> > From the data, it seems that is no significant difference in
> > performance. Please let me know your opinion.
> 
> The data is kind of scary, don't you think? The performance
> starts out as an improvement, but gets worse as file size gets
> bigger. This could be anomalous with your choice of file size.
> We see that kzalloc performance improves going from 1k to 4k.
> 
> Can you run the same test with 10 (20 would be better) iterations
> for 0, 1k, 3k, 4k, 5k, 20k, 100k and 1m?
> 
> I am curious now. I will run my own tests as well.
>

Yes, i too found it odd for 4k file taking less time than 1k size.
Actually, issue was probably because I was using different block size
for file creation in two cases.

The latency for creating 1024 files with average of  10 iterations for
below file size is as follows:
File size   With Kzalloc(in ms)  With kmem_cache(in ms)     %change
0               10610.6              10595.4                 -0.14 
1k              11832.3              11667.4                 -1.39 
4k              11861.2              11802.1                 -0.49 
20k             11991.7              11977.7                 -0.11 
50k             12242.9              12224.7                 -0.14 
100k            12638.9              12581                   -0.45

It seems kmem_cache has little better performance compared to kzalloc.
Please share your comments and your test results,if any.


 

