Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbaFTJOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:14:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:40464 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753858AbaFTJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:14:34 -0400
X-IronPort-AV: E=Sophos;i="5.00,743,1396972800"; 
   d="scan'208";a="32193642"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        "Richard Weinberger" <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>
Subject: RE: [PATCH] ns: introduce getnspid syscall
Thread-Topic: [PATCH] ns: introduce getnspid syscall
Thread-Index: AQHPix8FyYYtVdOGlkGmf8xJuFfmRZt5uGCg
Date: Fri, 20 Jun 2014 09:14:31 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E54B4DA@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140618175807.GA21565@redhat.com>
In-Reply-To: <20140618175807.GA21565@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5K9EhcQ032357



> -----Original Message-----
> From: Oleg Nesterov [mailto:oleg@redhat.com]
> Sent: Thursday, June 19, 2014 1:58 AM
> To: Chen, Hanxiao/³Â êÏÏö
> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Andrew Morton; Eric W. Biederman; Serge Hallyn; Daniel P. Berrange; Al Viro; David
> Howells; Richard Weinberger; Pavel Emelyanov; Vasiliy Kulikov; Gotou, Yasunori/
> Îåu ¿µÎÄ
> Subject: Re: [PATCH] ns: introduce getnspid syscall
> 
> On 06/17, Chen Hanxiao wrote:
> >
> > +SYSCALL_DEFINE4(getnspid, pid_t, pid, int, fd1, int, fd2, int, pidtype)
> > +{
> > +	struct file *file1 = NULL, *file2 = NULL;
> > +	struct task_struct *task;
> > +	struct pid_namespace *ns1, *ns2;
> > +	struct proc_ns *ei;
> > +	int ret = -1;
> > +
> > +	if (pidtype >= PIDTYPE_MAX)
> > +		return -EINVAL;
> > +
> > +	file1 = proc_ns_fget(fd1);
> > +	if (IS_ERR(file1))
> > +		return PTR_ERR(file1);
> > +	ei = get_proc_ns(file_inode(file1));
> > +	ns1 = (struct pid_namespace *)ei->ns;
> 
> and I am not sure this part is correct... shouldn't we also verify that
> ns_ops == pidns_operations ?
> 
You're right. We should check this part.

Thanks,
- Chen

> Perhaps it makes sense to generalize get_net_ns_by_fd() into
> "void *get_ns_by_fd(fd, type)"... this probably needs another "check-and-get"
> method in proc_ns_operations(). I dunno.
> 
> Oleg.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
