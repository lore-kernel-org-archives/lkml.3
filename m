Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaJBOoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:44:55 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:60899 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBOow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:44:52 -0400
Message-ID: <1412261057.5371.8.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 02 Oct 2014 16:44:17 +0200
In-Reply-To: <542D1726.3040801@draigBrady.com>
References: <cover.1411562410.git.ydroneaud@opteya.com>
	 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
	 <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain>
	 <542666B2.9080700@gmx.de>
	 <1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
	 <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
	 <1412230855.28184.5.camel@localhost.localdomain>
	 <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
	 <542D1726.3040801@draigBrady.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.160.90.1
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] fanotify: add a flag to allow setting O_CLOEXEC on
 event fd
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le jeudi 02 octobre 2014 à 10:13 +0100, Pádraig Brady a écrit :
> On 10/02/2014 08:52 AM, Yann Droneaud wrote:
> > In order to not potentially break applications which were
> > requesting O_CLOEXEC on event file descriptors but which
> > actually need it to be not effective as the kernel currently
> > ignore the flag, so the file descriptor is inherited accross
> > exec regardless of O_CLOEXEC (please forgive me for the
> > wording), this patch introduces FAN_FD_CLOEXEC flag to
> > fanotify_init() so that application can request O_CLOEXEC
> > to be effective.
> > Newer application would use FAN_FD_CLOEXEC flag along
> > O_CLOEXEC to enable close on exec on newly created
> > file descriptor:
> > 
> >   fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK|FAN_FD_CLOEXEC,
> >                      O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
> 
> Ugh really?
> IMHO there should be widespread or at least known breakage with
> O_CLOEXEC before adding messiness like this.

You should have read the other part of my message:

> > While I believe fanotify_init() must enable close-on-exec
> > when requested by userspace to prevent unwelcomed security
> > issue, I understand your concerns regarding the possible
> > breakage on userspace application requesting O_CLOEXEC
> > but relying on it not being enable on file descriptor
> > created for the events.
> 
> > So with a new flag to fanotify_init(), we could allow
> > newer applications to really enable O_CLOEXEC.
> 
> > But I feel bad to have to force application to specify
> > twice they want close on exec:
> >  - are you sure ?
> >  - are you really sure ?
> >  - is this your final answer ?
> >  ...


I'm not really fond of this option.

> It seems surprising to me that apps that would depend on
> O_CLOEXEC being ineffective.
> 

We have seen userspace developers making mistakes, and those mistakes
were mistakenly ignored by the kernel until someone try to fix the
mistake on kernel side, which broke the existing userspace application.

> please reconsider this one.
> 

I'm not going to promote this patch as it's a quick and dirty hack to
demonstrate what would be the other option.

Regards.

-- 
Yann Droneaud
OPTEYA


