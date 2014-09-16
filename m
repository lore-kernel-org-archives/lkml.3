Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaIPIzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:55:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30396 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaIPIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:55:08 -0400
X-AuditID: cbfee6a3-f792d6d00000146e-bc-5417fae9f7e5
Date: Tue, 16 Sep 2014 08:55:05 +0000 (GMT)
From: Shivnandan Kumar <shivnandan.k@samsung.com>
Subject: [PATCH] Security: List corruption occured during file system
 automation test
To: Shivnandan Kumar <shivnandan.k@samsung.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "cpgs ." <cpgs@samsung.com>, Ashish Kalra <ashish.kalra@samsung.com>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>,
        Rajat Suri <rajat.suri@samsung.com>
Reply-to: shivnandan.k@samsung.com
MIME-version: 1.0
X-MTR: 20140916085430016@shivnandan.k
Msgkey: 20140916085430016@shivnandan.k
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140913104002391@shivnandan.k
X-ParentMTR: 20140916070935212@shivnandan.k
X-ArchiveUser: 
X-CPGSPASS: Y
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <31742801.543561410857702467.JavaMail.weblogic@epml25>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t/tft2Xv8RDDFresFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MNdu/MhXcEa2Ycec0ewPjBNEuRk4OIQF1iU9r1zKB2BICJhIL
	G7qYIWwxiQv31rN1MXIB1cxhlLjZegIswSKgKvHx6zUWEJtNwEjizaQVrCC2sECoxN9bX5lA
	GkQEPjNJtHxqBetmFljFKLGvYyc7xDoliS+L54Kt4xUQlDg58wkLxDpViaW/zrFCxNUkri3c
	DRWXk1gy9TLUebwSM9qfwsWnfV0Ddaq0xPlZGxhhzl78/TFUnF/i2O0dQL0cYL1P7gfDjNm9
	+QsbhC0gMfXMQahWLYkzOxexQ9g6Ekfn3GGFGbPr1HJmmN6Gjb/BapgFFCWmdD+Esg0kjiya
	w4ruLV4BJ4krc++yTGCUm4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w1itOzC0uzUvXS87P
	3cQIjvVni3cw/j9vfYhRgINRiYfX45F4iBBrYllxZe4hRgkOZiUR3gefgEK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5428lBQkJpCeWpGanphakFsFkmTg4pRoYNT5nZAn+KjZfMHcjb4Lrqck+
	u//OmKlQd39X2PQNguZH3yoUuBmmNvCtWcZ2r0Ta2o/pYwi3yfE129Q2dnI1lU4WandYxbfy
	TW7xkWaju5/5MydMFJnoWxhXeylKNf1OUJKcXVu2qbDUE73WHPXdJgwpuqfM3MIV5/o71Xgs
	6LbovzxpmZsSS3FGoqEWc1FxIgCXJ/8k8QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G8tN3c026152



Hi  Stephen Smalley,

Reproduction path :- 
We do random  file system operation ( e.g. - Saving, Open, Play, Delete ) of files and during this some time we  abruptly power off the device.

Thanks,
Shivnandan

------- Original Message -------
Sender : Stephen Smalley<sds@tycho.nsa.gov>
Date : Aug 26, 2014 23:46 (GMT+09:00)
Title : Re: [PATCH] Security: List corruption occured during file system automation test

Do you have a reproducer test case to trigger the bug?

On 08/21/2014 06:29 AM, Shivnandan Kumar wrote:
> Dear Eric Paris,
> 
> Sorry for the late reply.
> Yes I have back trace and I am attaching it.
> 
> First time the issue is reproduced then I have added some debug statement in the 
> file kernel/security/selinux/hooks.c to narrow down the problem  and then we 
> reproduce the issue again.
> I am attaching  complete back trace as well as my additional debug patch for 
> your reference.
> 
> Thanks,
> 
> Shivnandan
> 
> ------- *Original Message* -------
> 
> *Sender* : Eric Paris
> 
> *Date* : Aug 14, 2014 05:27 (GMT+09:00)
> 
> *Title* : Re: [PATCH] Security: List corruption occured during file system 
> automation test
> 
> Do you have a backtrace?
> 
> On Wed, Aug 13, 2014 at 8:30 AM, Al Viro wrote:
>  > On Wed, Aug 13, 2014 at 05:04:13PM +0530, shivnandan.k@samsung.com wrote:
>  >> From: Shivnandan Kumar
>  >>
>  >> List element was freed by  inode_free_security and then it uses rcu
>  >> element to point inode_free_rcu, since it inside a union so it
>  >> shares memory, sb_finish_set_opts now also try to free list element,
>  >
>  > How in hell does it find that element?
> 
> Thanks and Regards,
> 
> Shivnandan Kumar
> 
> 
> 
> _______________________________________________
> Selinux mailing list
> Selinux@tycho.nsa.gov
> To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
> To get help, send an email containing "help" to Selinux-request@tycho.nsa.gov.
> 





Thanks and Regards,
Shivnandan KumarˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
