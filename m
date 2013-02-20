Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935600Ab3BTNqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:46:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:12607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935580Ab3BTNqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:46:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="289567081"
From: "Li, Fei" <fei.li@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "pavel@ucw.cz" <pavel@ucw.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Wang, Biao" <biao.wang@intel.com>
Subject: RE: [PATCH] freezer: configure user space process frozen along with
 kernel threads
Thread-Topic: [PATCH] freezer: configure user space process frozen along
 with kernel threads
Thread-Index: AQHODxBpX7dUZj4OyEGrpnYpQgXwf5iB7oSAgADSlDA=
Date: Wed, 20 Feb 2013 13:46:47 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634403712@SHSMSX102.ccr.corp.intel.com>
References: <1361326525.9753.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130220090507.GV20312@moon>
In-Reply-To: <20130220090507.GV20312@moon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Cyrill Gorcunov [mailto:gorcunov@gmail.com] On Behalf Of Cyrill
> Gorcunov
> Sent: Wednesday, February 20, 2013 5:05 PM
> To: Li, Fei
> Cc: pavel@ucw.cz; rjw@sisk.pl; Brown, Len; mingo@redhat.com;
> peterz@infradead.org; akpm@linux-foundation.org; viro@zeniv.linux.org.uk;
> ebiederm@xmission.com; rientjes@google.com; linux-kernel@vger.kernel.org;
> linux-pm@vger.kernel.org; Liu, Chuansheng; Wang, Biao
> Subject: Re: [PATCH] freezer: configure user space process frozen along with
> kernel threads
> 
> On Wed, Feb 20, 2013 at 10:15:25AM +0800, Li Fei wrote:
> >
> > +#ifdef CONFIG_FREEZER
> > +
> > +static ssize_t freeze_late_read(struct file *file, char __user *buf,
> > +					size_t count, loff_t *ppos)
> > +{
> > +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> > +	char buffer[PROC_NUMBUF];
> > +	int freeze_late;
> > +	size_t len;
> > +	if (!task)
> > +		return -ESRCH;
> > +	freeze_late = (task->flags & PF_FREEZER_LATE) ? 1 : 0;
> > +	len = snprintf(buffer, sizeof(buffer), "%d\n", freeze_late);
> > +	return simple_read_from_buffer(buf, count, ppos, buffer, len);
> > +}
> 
> Don't you need put_task_struct() once you grabbed it?

Thanks for your reminder. I'll update it in later version.

Best Regards,
Li Fei
