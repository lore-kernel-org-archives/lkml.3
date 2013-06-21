Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423721Ab3FUSvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:51:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423590Ab3FUSvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:51:06 -0400
Date: Fri, 21 Jun 2013 11:50:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
Message-ID: <20130621185056.GA23473@kroah.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <20130621165142.GA32125@kroah.com>
 <51C48745.9030304@zytor.com>
 <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:44:22AM -0700, Yinghai Lu wrote:
> On Fri, Jun 21, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 06/21/2013 09:51 AM, Greg KH wrote:
> >
> > I suspect the cutoff for this should be a lot lower than 8 TB even, more
> > like 128 GB or so.  The only concern is to not set the cutoff so low
> > that we can end up running out of memory or with suboptimal NUMA
> > placement just because of this.
> 
> I would suggest another way:
> only boot the system with boot node (include cpu, ram and pci root buses).
> then after boot, could add other nodes.

What exactly do you mean by "after boot"?  Often, the boot process of
userspace needs those additional cpus and ram in order to initialize
everything (like the pci devices) properly.

thanks,

greg k-h
