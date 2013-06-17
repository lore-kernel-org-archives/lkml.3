Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3FQON7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:13:59 -0400
Received: from shell.v3.sk ([195.168.3.45]:41993 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3FQON5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:13:57 -0400
Subject: Re: [PATCH] [media] usbtv: Add driver for Fushicai USBTV007 video
 frame grabber
From: Lubomir Rintel <lkundrak@v3.sk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201306120949.44163.hverkuil@xs4all.nl>
References: <1370857931-6586-1-git-send-email-lkundrak@v3.sk>
	 <201306101305.05038.hverkuil@xs4all.nl>
	 <1370885934.9757.11.camel@hobbes.kokotovo>
	 <201306120949.44163.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jun 2013 16:13:49 +0200
Message-ID: <1371478429.23946.1.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 09:49 +0200, Hans Verkuil wrote:
...
> > > > +static int usbtv_queryctrl(struct file *file, void *priv,
> > > > +				struct v4l2_queryctrl *ctrl)
> > > > +{
> > > > +	return -EINVAL;
> > > > +}
> > > 
> > > Drop this ioctl. If it doesn't do anything, then don't specify it.
> > 
> > It actually does something; EINVAL here for any ctrl signals there's
> > zero controls.
> > 
> > When undefined, ENOTTY that is returned is considered invalid by
> > gstreamer source.
> 
> What version of gstreamer are you using? Looking at the gstreamer code it
> seems that it can handle ENOTTY at least since September last year. Not handling
> ENOTTY is an application bug (there are other - rare - drivers that do not
> have any controls) and as such I really don't like seeing a workaround like
> this in a driver, especially since this seems like it should be working fine
> with the latest gstreamer.

I was using GStreamer from RHEL6. I retried with Fedora 17 and it worked
fine.

Regards,
Lubo

-- 
Lubomir Rintel <lkundrak@v3.sk>

