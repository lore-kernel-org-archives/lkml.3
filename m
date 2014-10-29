Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaJ2IzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:55:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43290 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaJ2IzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:55:14 -0400
X-AuditID: cbfee691-f79b86d000004a5a-fb-5450ab6e4f19
Date: Wed, 29 Oct 2014 14:41:34 +0530
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
Message-id: <20141029144134.46e16fb1@rohitk-ubuntu.sisodomain.com>
In-reply-to: <544E71F8.60301@schaufler-ca.com>
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
 <543FF121.7000502@schaufler-ca.com>
 <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
 <544129FD.8060902@schaufler-ca.com>
 <1413563667.96709.YahooMailNeo@web160104.mail.bf1.yahoo.com>
 <544153D1.50304@schaufler-ca.com> <544D94C1.8010402@schaufler-ca.com>
 <20141027122413.7edd8ee1@rohitk-ubuntu.sisodomain.com>
 <544E71F8.60301@schaufler-ca.com>
Organization: Samsung
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkTjdvdUCIQfdxDYs569ewWdzb9ovN
	4uUhTYtFuxcwWcz+NYnJou9xkMXlXXPYLD70PGKzuH7P3qLv+2F2i29vb7NbnL9wjt1iSt9d
	Rgdej2u7Iz1OzPjN4tFxq4HV4+PTWywefVtWMXoc3b+IzePzJjmPWbMOMwVwRHHZpKTmZJal
	FunbJXBlnP1/nL2gy6DiRc9xlgbGfrUuRk4OCQETicNHzjFD2GISF+6tZ+ti5OIQEljKKHF7
	xklmmKJnD/4wgdhCAosYJRovuEIU9TJJdP2bzQ6SYBFQlVi4dyYLiM0moCTx/9VcNhBbREBH
	Yt+e5+wgDcwCv1gkeq9eBysSFoiS6Fm4nBHE5hVwkmiZdBtsEKeAnsTvraeYIbatZZbYPycc
	xOYXEJU4vHA71EU2Eqt3rmOG6BWU+DH5HthMZgEtic3bmlghbG2JJ+8usIIslhCYyiHxt/8s
	M8SlAhLfJh8CauAASshKbDoANVNS4uCKGywTGMVnIRk7C8nYWUjGLmBkXsUomlqQXFCclF5k
	qlecmFtcmpeul5yfu4kRGOOn/z2buIPx/gHrQ4wCHIxKPLwvkgNChFgTy4orcw8xmgJdMZFZ
	SjQ5H5hI8kriDY3NjCxMTUyNjcwtzZTEeXWkfwYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YDzP4azYrbLv9v/AW5axavfMWQ0k2Q9r/Lnuy7QiKnL6jAvsfy7Oylytmm/zzX3z5V87lv2+
	HVNT4FPddXGRJovMdSORdnbRKRuusKeZ8OcfkDnJVfDSXjj+/iPmZOM/CndyElY/2WrFuEDt
	zY15Qm1hHTc9J93pF7iz46/CWsee1VOy5v27aq/EUpyRaKjFXFScCAArvT3Z7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd281QEhBge+yVrMWb+GzeLetl9s
	Fi8PaVos2r2AyWL2r0lMFn2Pgywu75rDZvGh5xGbxfV79hZ93w+zW3x7e5vd4vyFc+wWU/ru
	MjrwelzbHelxYsZvFo+OWw2sHh+f3mLx6NuyitHj6P5FbB6fN8l5zJp1mCmAI6qB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bZ/8fZC7oMKl70HGdpYOxX62Lk5JAQMJF4
	9uAPE4QtJnHh3no2EFtIYBGjROMF1y5GLiC7l0mi699sdpAEi4CqxMK9M1lAbDYBJYn/r+aC
	NYgI6Ejs2/OcHaSBWeAXi0Tv1etgRcICURI9C5czgti8Ak4SLZNugw3iFNCT+L31FDPEtrXM
	EvvnhIPY/AKiEocXbmeGuMhGYvXOdcwQvYISPybfA5vJLKAlsXlbEyuErS3x5N0F1gmMgrOQ
	lM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEJ5Jn0DsZVDRaHGAU4GJV4
	eF8kB4QIsSaWFVfmHmKU4GBWEuHdYQ4U4k1JrKxKLcqPLyrNSS0+xGgKDJqJzFKiyfnA5JZX
	Em9obGJuamxqaWJhYmapJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoHRMH3i3N2enXNtXx7V
	cja/wLNrn95WZZtHz/qSVu4sjxC4zhCbLsB6WeiTyOrjf2SNI/9GMlm/s3B+KuXT89Ez9tEG
	J7eio1KSPh0MHe/sWZ9d4zC5kbX9le2pnktCZUFzZs/rvLtlQXl/b0GXxeawMzELS862CS3+
	1n2K4bWH53HzmtuGkg5KLMUZiYZazEXFiQCsX3mNNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014 09:25:28 -0700
Casey Schaufler <casey@schaufler-ca.com> wrote:

> On 10/26/2014 11:54 PM, Rohit wrote:
> > On Sun, 26 Oct 2014 17:41:37 -0700
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> >
> >> On 10/17/2014 10:37 AM, Casey Schaufler wrote:
> >>> On 10/17/2014 9:34 AM, PINTU KUMAR wrote:
> >>>> Hi,
> >>>>
> >>>>
> >>>>> ________________________________
> >>>>> From: Casey Schaufler <casey@schaufler-ca.com>
> >>>>> To: Rohit <rohit.kr@samsung.com> 
> >>>>> Cc: akpm@linux-foundation.org; james.l.morris@oracle.com;
> >>>>> serge@hallyn.com; linux-security-module@vger.kernel.org;
> >>>>> linux-kernel@vger.kernel.org; cpgs@samsung.com;
> >>>>> pintu.k@samsung.com; vishnu.ps@samsung.com;
> >>>>> iqbal.ams@samsung.com; ed.savinay@samsung.com;
> >>>>> me.rohit@live.com; pintu_agarwal@yahoo.com; Casey Schaufler
> >>>>> <casey@schaufler-ca.com> Sent: Friday, 17 October 2014 8:08 PM
> >>>>> Subject: Re: [PATCH v2] Security: smack: replace kzalloc with
> >>>>> kmem_cache for inode_smack
> >>>>>
> >>>>>
> >>>>> On 10/17/2014 4:42 AM, Rohit wrote:
> >>>>>> On Thu, 16 Oct 2014 09:24:01 -0700
> >>>>>> Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>>>
> >>>>>>> On 10/15/2014 5:10 AM, Rohit wrote:
> >>>>>>>> The patch use kmem_cache to allocate/free inode_smack since
> >>>>>>>> they are alloced in high volumes making it a perfect case for
> >>>>>>>> kmem_cache.
> >>>>>>>>
> >>>>>>>> As per analysis, 24 bytes of memory is wasted per allocation
> >>>>>>>> due to internal fragmentation. With kmem_cache, this can be
> >>>>>>>> avoided.
> >>>>>>> What impact does this have on performance? I am much more
> >>>>>>> concerned with speed than with small amount of memory.
> >>>>>>>
> >>>>>> I think there should not be any performance problem as such.
> >>>>>> However, please let me know how to check the performance in
> >>>>>> this case.
> >>>>> Any inode intensive benchmark would suffice. Even the classic
> >>>>> kernel build would do.
> >>>>>
> >>>>>> As far as i know, kzalloc first finds the kmalloc_index
> >>>>>> corresponding to the size to get the kmem_cache_object and then
> >>>>>> calls kmem_cache_alloc with the kmalloc_index(kmem_cache
> >>>>>> object). Here, we create kmem_cache object specific for
> >>>>>> inode_smack and directly calls kmem_cache_alloc() which should
> >>>>>> give better performance as compared to kzalloc.
> >>>>> That would be my guess as well, but performance is tricky.
> >>>>> Sometimes things that "obviously" make performance better make
> >>>>> it worse. There can be unanticipated side effects.
> >>>>>
> >>>>>
> >>>>>> Please let me know your comments.
> >>>>> If you can run any sort of test that demonstrates this change
> >>>>> does not have performance impact, I'm fine with it. Smack is
> >>>>> being used in small devices, and both memory use and
> >>>>> performance are critical to the success of these devices. Of
> >>>>> the two, performance is currently more of an issue.
> >>>>>
> >>>> SMACK is used heavily in Tizen. We verified these changes for one
> >>>> of Tizen project. During boot time we observed that this object
> >>>> is used heavily, as identified by kmalloc-accounting. After
> >>>> replacing this we did not observe any difference in boot time.
> >>>> Also there was no side-effects seen so far. If you know of any
> >>>> other tests, please let us know. We will also try to gather some
> >>>> performance stats and present here.
> >>> We need to be somewhat more precise than "did not observe any
> >>> difference in boot time". The ideal benchmark would perform lots
> >>> of changes to the filesystem without doing lots of IO. One process
> >>> that matches that profile fairly well is a kernel make. I would be
> >>> satisfied with something as crude as using time(1) on a small (5?)
> >>> number of clean kernel makes each with and without the patch on
> >>> the running kernel. At the level of accuracy you usually get from
> >>> time(1) you won't find trivial differences, but if the change is a
> >>> big problem (or a big win) we'll know.
> >> I have not seen anything indicating that the requested performance
> >> measurements have been done. I have no intention of accepting this
> >> without assurance that performance has not been damaged. I request
> >> that no one else carry this forward, either. The performance impact
> >> of security facilities comes under too much scrutiny to ignore it.
> >>
> >>> ... 
> > Sorry for the delay as I was on holiday for last week.
> > Will verify the performance impact as per your suggestion.
> > We verified it only on Tizen based ARM board, so building kernel on
> > it is not possible.
> > I found http://elinux.org/images/0/06/Buzov-SMACK.pdf (slides -
> > 35-37) for performance verification of smack. It checks performance
> > of file creation and copy in tmpfs. 
> > Please let me know whether the procedure mentioned in the above
> > mentioned slide is fine, else please suggest some other way to check
> > performance on the target board.
> 
> The technique outlined by Buzov should provide adequate evidence.
We carried out file creation of 0, 1k and 4k size for 1024 files and measured the time taken.
It was done for 5 iterations for each case with kzalloc and kmem_cache on a board with 512MB RAM and 1.2 GHz dual core arm processor.
The average latency is as follows :
File size   with kzalloc(in ms)   with kmem_cache(in ms)       %change
    0           10925.6               10528.8                   -3.63
   1k           11909.8               11617.6                   -2.45
   4k           11632.2               11873.2                   +2.07

>From the data, it seems that is no significant difference in performance.
Please let me know your opinion.
> 
> >
> >
> > Regards,
> > Rohit
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-security-module" in the body of a message to
> > majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> >
> 

