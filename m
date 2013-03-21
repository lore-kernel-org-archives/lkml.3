Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab3CUQJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907Ab3CUQJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:09:51 -0400
Date: Thu, 21 Mar 2013 12:04:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Message-ID: <20130321160441.GB6575@redhat.com>
References: <1363802506.2580.55.camel@falcor1.watson.ibm.com>
 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
 <20130321134348.GA3934@redhat.com>
 <20130321153725.GA3656@austin.hallyn.com>
 <20130321155220.GL3934@redhat.com>
 <20130321155823.GA4438@austin.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321155823.GA4438@austin.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:58:23AM -0500, Serge E. Hallyn wrote:
> Quoting Vivek Goyal (vgoyal@redhat.com):
> > On Thu, Mar 21, 2013 at 10:37:25AM -0500, Serge E. Hallyn wrote:
> > > Quoting Vivek Goyal (vgoyal@redhat.com):
> > > ...
> > > > Giving CAP_MODIFY_KERNEL to processess upon signature verification
> > > > will simplify things a bit.
> > > > 
> > > > Only thing is that signature verification alone is not sufficient. We
> > > > also need to make sure after signature verification executable can
> > > > not be modified in memory in any way. So that means atleast couple of
> > > > things.
> > > 
> > > Also what about context?  If I construct a mounts namespace a certain
> > > way, can I trick this executable into loading an old singed bzImage that
> > > I had laying around?
> > 
> > We were thinking that /sbin/kexec will need to verify bzImage signature
> > before loading it. 
> > 
> > Key for verification is in kernel so idea was to take kernel's help
> > in verifying signature.
> > 
> > Not sure how exactly the interface should look like. 
> > 
> > - I was thinking may be process can mmap() the bzImage with MAP_LOCKED.
> >   We can create additional flag say MAP_VERIFY_SIG_POST, which tries
> >   to verify signature/integrity of mapped region of file after mapping and
> >   locking pages and mmap() fails if signature verification fails.
> > 
> > There have been suggestions about creating new system call altogether.
> > 
> > > 
> > > ISTM the only sane thing to do, if you're going down this road,
> > > is to have CAP_MODIFIY_KERNEL pulled from bounding set for everyone
> > > except a getty started by init on ttyS0.  Then log in on serial
> > > to update.  Or run a damon with CAP_MODIFIY_KERNEL which listens
> > > to a init_net_ns netlink socket for very basic instructions, like
> > > "find and install latest signed bzImage in /boot".  Then you can
> > > at least trust that /boot for that daemon is not faked.
> > 
> > daemon does not have the key and can't verify signature of signed
> > bzImage. Even if it had the key, it can't trust the crypto code for
> > signature verification as none of that is signed.
> 
> I'm not saying not to use the kernel to verify the signature.

Ok. So why can't /sbin/kexec can do the verification of bzImage with
kernel's help. Due to crafted /boot/ it might load old signed bzImage,
but it can't load unsigned/untrusted code on secureboot system at ring 0.

I am hoping I did not miss your point entirely.

Thanks
Vivek
