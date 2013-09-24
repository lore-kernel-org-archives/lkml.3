Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3IXNCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:02:49 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:50072 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IXNCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:02:48 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-9a-52418d765486
Date: Tue, 24 Sep 2013 10:02:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, t.figa@samsung.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
Message-id: <20130924100240.211dcaa3@samsung.com>
In-reply-to: <1583471.Ys4OY3iSLA@amdc1032>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <13162989.WhfDRzW6dg@amdc1032> <52415ED9.3030407@samsung.com>
 <1583471.Ys4OY3iSLA@amdc1032>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/hYN2yXscggx33dCw2zljPanG26Q27
	xabH11gtLu+aw2bRs2Erq8XpNaeYLQ6/aWe1WD/jNYvFvPaXrA6cHpuX1HscfLeHyaNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgyjs19zFbwjr9i59MH7A2Me3i6GDk5JARMJE49aWWEsMUk
	Ltxbz9bFyMUhJLCEUWLvvm+MEE43k8TTLzOZQKpYBFQlzs/7AWazCRhJvGpsYQWxRQQsJNau
	eMsC0sAsMJVJYsmHZWwgCWEBX4nL5++zg9i8AoYSH5ZsBLM5BbQkdnedY4fYsJZR4v/Bl8xd
	jBxAdzhJbJ3qC1EvKPFj8j0WEJsZqH7ztiZWCFteYvOat8wTGAVmISmbhaRsFpKyBYzMqxhF
	S4uTC4qT0nON9IoTc4tL89L1kvNzNzFCAr54B+OLDVaHGAU4GJV4eDWSHYKEWBPLiitzDzFK
	cDArifBq1joGCfGmJFZWpRblxxeV5qQWH2Jk4uCUamAUP92yjbPt6UwB571fdtoI6Hk83SKg
	veaIs7Kc/ifFn7bCLGcsNq/8q/b2TNiC+S5hS70PdYkrOe7wTbit++jL1Hm3/VUnTlRZ8llR
	nENLbaWs4u7VJ+403C+fs+nX3BV81T95iuLu7ORyDP1+2pxnB5vt196cCW0T+ma/vi1mMsn4
	QN6ka1u4lViKMxINtZiLihMBvRutSVYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 24 Sep 2013 12:33:34 +0200
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:

> 
> Hi Tomasz,
> 
> On Tuesday, September 24, 2013 11:43:53 AM Tomasz Stanislawski wrote:
> > Hi,
> > 
> > On 09/23/2013 05:48 PM, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi Tomasz,
> > > 
> > > On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
> > >> Hello,
> > >> May I ask what is the rationale for this patch?
> > >> To reduce a few lines of code?
> > > 
> > > This patch makes source code more generic-like and easier to follow (mxd_r*
> > 
> > more generic(-like?) - NOT. Using mxr_ macros is a more generic way to produce logs
> 
> Using mxr_* macros is not more generic, don't be silly. :)

Let me give my 2 cents on it: it used to be common on media drivers to
define their own print macros. The rationale for that is because the
existing macros, on that time (kernel 2.2), weren't good enough[1].
Other drivers just followed it due to cut-and-paste.

However, nowadays, most developers are just sticking with the existing
common debug infrastructure (either dev_* or pr_* - being the last more
used). By using them, Kernel janitors can do a better job, as they may
have scripts already prepared to check issues there.

I prefer the usage of pr_* macros, as they allow debug messages to be
selectively enabled/disabled, if dynamic printk's are enabled. So,
a change like that actually improves the debug capability on a given 
driver.

So, IMHO, the better would be to change the patch to use pr_* macros,
and follow Joe's suggestions to improve it.

Regards,
Mauro


[1] on other drivers that create their own macros, the usual prefix is the
name of the driver (so, on em28xx, it is em28xx_dbg, and so on). In this 
case, the driver is s5p_tv. So, a macro following the old way should be 
called as s5p_tv_dbg. Yet, it is takes just a fraction of time to identify
them as printk-alike macros, as all those macros are similar.

Cheers,
Mauro
