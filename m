Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbaEMJP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:15:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1814 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759974AbaEMJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:15:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,1042,1389715200"; 
   d="scan'208";a="30448064"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: RE: [Resend][PATCH] ns,proc: introduce pid_in_ns
Thread-Topic: [Resend][PATCH] ns,proc: introduce pid_in_ns
Thread-Index: AQHPYLsCD7u2HoeO10COgZs+VIO3TJs8gc4Q
Date: Tue, 13 May 2014 09:15:55 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5119FF@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1398415405-19872-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<20140425185645.GA10637@redhat.com> <87a9b95icy.fsf@x220.int.ebiederm.org>
In-Reply-To: <87a9b95icy.fsf@x220.int.ebiederm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.62]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4D9G9Sg025771



> -----Original Message-----
> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Saturday, April 26, 2014 3:18 AM
> To: Oleg Nesterov
> Cc: Chen, Hanxiao/³Â êÏÏö; containers@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org; Andrew Morton; Serge Hallyn; Daniel P. Berrange;
> Al Viro; David Howells
> Subject: Re: [Resend][PATCH] ns,proc: introduce pid_in_ns
> 
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > On 04/25, Chen Hanxiao wrote:
> >>
> >> We lacked of convenient method of getting the pid inside containers.
> 
> Are unix domain sockets not convinient?
> 

It's a very good method, but not so directly for just pid translation.

> >> If some issues occurred inside container guest, host user
> >> could not know which process is in trouble just by guest pid:
> >> the users of container guest only knew the pid inside containers.
> >> This will bring obstacle for trouble shooting.
> >>
> >> This patch introduces pid_in_ns:
> >> If one process is in init_pid_ns, /proc/PID/pid_in_ns
> >> equals to /proc/PID;
> >> if one process is in pidns, /proc/PID/pid_in_ns
> >> will tell the pid inside containers;
> >> if pidns is nested, it depends on which pidns are you in.
> >
> > Yes another /proc/pid/ file...
> >
> > Perhaps it would be better to change /proc/pid/status["Pid:"] to report the
> > list of pid_nr's, from its namespace up to the observer's namespace. The same
> > for "Tgid:".
> >
> > (Hmm. And why "Ngid:" was inserted between tid and tgid ?)
> 
> Add to that Ngid has a completely hosed implementation.  It is a pid
> stored in a pid_t, not a struct pid *.  Sigh.
> 
> I am getting more and more tempted to obliterate task->pid.  It just
> encourages bad code.
> 
> >> +int proc_pid_in_ns(struct seq_file *m, struct pid_namespace *ns,
> >> +			struct pid *pid, struct task_struct *task)
> >> +{
> >> +	pid_t pid_in_ns;
> >> +	unsigned int level;
> >> +
> >> +	level = pid->level;
> >> +	pid_in_ns = task_pid_nr_ns(task, pid->numbers[level].ns);
> >
> > This looks overcomplicated or I missed something?
> 
> I do think if we care we need to print the entire set of pids.
> I don't know if /proc/pid/status is the proper place but ...
> 

Let's print the entire set of pids in /proc/pid/status.

> Eric

Thanks for the comments.
v2 will come soon.

- Chen

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
