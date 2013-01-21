Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3AUSpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:45:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33191 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3AUSo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:44:58 -0500
Message-ID: <1358793893.2406.143.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
Date: Mon, 21 Jan 2013 13:44:53 -0500
In-Reply-To: <20130121154501.GA27617@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <1358437021.2689.52.camel@falcor1> <20130117155154.GC12165@redhat.com>
	 <1358440365.2689.72.camel@falcor1> <20130117173605.GB2237@redhat.com>
	 <1358702400.2406.103.camel@falcor1.watson.ibm.com>
	 <20130121154501.GA27617@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012118-4834-0000-0000-000002D546F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 10:45 -0500, Vivek Goyal wrote:
> On Sun, Jan 20, 2013 at 12:20:00PM -0500, Mimi Zohar wrote:
> > On Thu, 2013-01-17 at 12:36 -0500, Vivek Goyal wrote:
> > > On Thu, Jan 17, 2013 at 11:32:45AM -0500, Mimi Zohar wrote:
> > > 
> > > [..]
> > > > > > At this point, why would you want yet another method for signing files?
> > > > > 
> > > > > Are you saying that append signature instead of putting them in a section
> > > > > or are you saying that just use IMA.
> > > > > 
> > > > > - For the first, I am fine with appending too if that works better. So
> > > > >   what's wrong with current implementation. Just because we append the
> > > > >   signatures in case of modules, we should follow the same thing for
> > > > >   executables too?
> > > > 
> > > > No, I was saying that if this patch set were to be upstreamed, then the
> > > > signature verification, at least for ELF modules and ELF executables,
> > > > should be the same.  The patch would then be a lot smaller.
> > > 
> > > I don't think that patch is lot smaller. Initially I had written code
> > > where signatures were appended. Parsing the signature is little different
> > > from module. In case of modules, whole file is already in memory and
> > > in case of executables, we are reading selected portions of file in
> > > buffer. 
> > 
> > Have you looked at the original kernel module signature verification
> > code as posted by David?  It did something similar, but was not
> > upstreamed.
> 
> I have. I think keeping code in a section makes stripping of section
> easy. Anyway, these sections are not loaded in memory at file exec
> time so it should be fine.
> 
> So appending signature is easy and I can change the implementation to
> do it like modules.
> 
> But please give a more stronger reason that why it should be appened
> to executable then put in a section.

There are two existing upstreamed methods for verifying the integrity of
files.  One uses a file descriptor, the other is memory based, for the
specific use case, where a file descriptor is not available.  The real
question is what benefit there is to adding another method?  That
question needs to be addressed in the patch description.

thanks,

Mimi

