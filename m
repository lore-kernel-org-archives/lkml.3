Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaFXWfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:35:15 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:33514
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaFXWfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:35:13 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=FZq5xfO6 c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=JT5DoUvwEhkA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=EC2RDjQBYc1CMKd1EHcA:9
 a=yrveiXnRl9DWLnRs:21 a=FW0s1fJLZVgu1VKU:21 a=QEXdDO2ut3YA:10
Date: Tue, 24 Jun 2014 23:35:09 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <greg@kroah.com>, Michael Marineau <mike@marineau.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_UEVENT_HELPER default
Message-ID: <20140624223509.GA21551@milliways>
References: <Pine.LNX.4.44L0.1406241421050.888-100000@iolanthe.rowland.org>
 <CAHW-aUfJedVUkYxxD-GSNaQg+FvXDXGW9Q9HaTknBeGZMF9REA@mail.gmail.com>
 <20140624183310.GA4955@kroah.com>
 <53A9D7AE.8000305@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A9D7AE.8000305@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 12:55:26PM -0700, Andy Lutomirski wrote:
> On 06/24/2014 11:33 AM, Greg KH wrote:
> > On Tue, Jun 24, 2014 at 11:30:05AM -0700, Michael Marineau wrote:
> >> On Jun 24, 2014 11:23 AM, "Alan Stern" <stern@rowland.harvard.edu> wrote:
> >>>
> >>> Michael and Greg:
> >>>
> >>> The help text for CONFIG_UEVENT_HELPER says (among other things):
> >>>
> >>>           This should not be used today, because usual systems create
> >>>           many events at bootup or device discovery in a very short time
> >>>           frame.
> >>>
> >>> If it shouldn't be used, why does it default to 'y'?
> >>>
> >>> Alan Stern
> >>>
> >>
> >> To introduce the option but not change the default behavior. (yet?) I don't
> >> really have an opinion one way or the other, I just defaulted to being
> >> conservative.
> > 
> > Yes, being conservative is good as turning this off with older systems
> > (like the pathological Fedora 3 system that some kernel developers still
> > use for testing), would result in a non-booting box.  So if you know
> > that your system is "new enough", it's safe to turn off, but if you have
> > a doubt, leave it on to be safe.
> 
> As far as I know, there's no real requirement that a defconfig kernel be
> able to boot old userspace.  We want an oldconfig kernel to be able to
> boot old userspace, but changing the default won't affect that.
> 
> For example, a defconfig kernel won't boot opensuse 9.
> 
> --Andy

 I noticed this help message yesterday, and decided that I
almost-certainly did NOT want it (that system is about 6 weeks old,
with then-current releases of everything).  But I was not able to
complete the kernel build because of other problems (possibly
related to gcc-4.9.1) and I have other things to do at the moment.
All of which means that I can not, for the moment, review what will
happen if I let this option get enabled.

 Two things about this default concern me:

(i.) I got the option with 'make oldconfig' and, after reading the
help, made a decision.  But, in the absence of other problems, and
if the help text is correct, it looks as if a kernel built after
accepting the default 'Y' here with recent userspace might grind to
a halt after "successfully" booting?  That sounds slightly better
than "fails to boot", but only slightly.  Maybe the problem needs
a lot of modules, or is it something like "it will hang for a minute,
then boot" ?

(ii.) I understand that people continue to use ancient userspace,
and for that the 'Y' option is needed.  Using ancient userspace is
a worthwhile thing for _somebody_ to try.  But where is the line
between "you need to enable this" and "enabling this might be a
really bad idea" ?  Maybe a specific version of udev ?

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
