Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab3C2EEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 00:04:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60374 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3C2EEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 00:04:47 -0400
Date: Fri, 29 Mar 2013 13:04:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@redhat.com,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysfs: Add crash_notes_size to export percpu note
 size
Message-ID: <20130329040445.GH13429@verge.net.au>
References: <5153FC27.70001@cn.fujitsu.com>
 <51550F8B.1000402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51550F8B.1000402@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:50:35AM +0800, Zhang Yanfei wrote:
> Hi, simon
> 
> I forgot to add your email in the CC, could you please help
> reviewing this patch since I will send the kexec-tools patch
> if this patch is accepted.
> 
> Thanks
> Zhang
> 
> 于 2013年03月28日 16:15, Zhang Yanfei 写道:
> > For percpu notes, we are exporting only address and not size. So
> > the userspace tool kexec-tools is putting an upper limit of 1024
> > and putting the value in p_memsz and p_filesz fields. So the patch
> > add the new sysfile crash_notes_size to export the exact percpu
> > note size and let the kexec-tools parse it intead of using 1024.
> > 
> > The idea came from Vivek Goyal. And a later patch will be sent to
> > kexec-tools to let it parse the size.

Acked-by: Simon Horman <horms@verge.net.au>

> > 
> > Cc: Greg KH <gregkh@linuxfoundation.org>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > ---
> >  drivers/base/cpu.c |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > index fb10728..a55b590 100644
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@ -132,6 +132,17 @@ static ssize_t show_crash_notes(struct device *dev, struct device_attribute *att
> >  	return rc;
> >  }
> >  static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
> > +
> > +static ssize_t show_crash_notes_size(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     char *buf)
> > +{
> > +	ssize_t rc;
> > +
> > +	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
> > +	return rc;
> > +}
> > +static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
> >  #endif
> >  
> >  /*
> > @@ -259,6 +270,9 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
> >  #ifdef CONFIG_KEXEC
> >  	if (!error)
> >  		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
> > +	if (!error)
> > +		error = device_create_file(&cpu->dev,
> > +					   &dev_attr_crash_notes_size);
> >  #endif
> >  	return error;
> >  }
> 
> 
