Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3BSMrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3BSMrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:47:18 -0500
Date: Tue, 19 Feb 2013 09:46:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, rjw@sisk.pl, linux-pm@vger.kernel.org
Subject: Re: SYSFS "errors"
Message-ID: <20130219094640.2abf1a66@redhat.com>
In-Reply-To: <20130219123502.GD26623@pd.tnic>
References: <20130218184742.5a4c3c06@redhat.com>
	<20130218215434.GB16794@kroah.com>
	<20130218221306.GA21493@pd.tnic>
	<20130218222618.GA21818@kroah.com>
	<20130218224405.GB21493@pd.tnic>
	<20130219070310.2cadad7a@redhat.com>
	<20130219101121.GJ23197@arwen.pp.htv.fi>
	<20130219081149.46972f56@redhat.com>
	<20130219114345.GA26623@pd.tnic>
	<20130219091610.2b746a30@redhat.com>
	<20130219123502.GD26623@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 19 Feb 2013 13:35:02 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Tue, Feb 19, 2013 at 09:16:10AM -0300, Mauro Carvalho Chehab wrote:
> > I'm not sure if is there a way to pass fs permissions to something similar
> > to device_create_file().
> 
> struct device_attribute.attr.mode? I.e., second arg.

Ah, now I see what you're meaning. That would require to dynamically
create a per-mci DEVICE_ATTR().

> > On both cases, an error will happen at open:
> > 	- if file doesn't exist (this approach), it will return -ENOENT;
> > 	- if file is opened with wrong permissions, open will return -EPERM.
> > 
> > However, if the file is not created, readdir() won't show the file.
> 
> Right, and in that case userspace which *assumes* it is always created -
> like it is now - will fail when accessing it.
> 
> If simply you adjust the attributes accordingly but *always* create the
> file and it has the correct permissions, everyone is happy. Right?

No, on both cases, open() will return an error (-ENOENT against -EPERM). 

If userspace doesn't check if open() failed, I can't see why
changing the open return error code would help.

-- 

Cheers,
Mauro
