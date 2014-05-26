Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaEZURl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:17:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaEZURj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:17:39 -0400
Date: Mon, 26 May 2014 16:17:32 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-audit@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        containers <containers@lists.linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, sgrubb@redhat.com,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
Message-ID: <20140526201732.GD8079@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com>
 <CAHO5Pa0EdUsV9jJuLbkmbvFyopecQiUDZd0UasAJ5kMhtsVxjQ@mail.gmail.com>
 <20140526165858.GC8079@madcap2.tricolour.ca>
 <CAKgNAkgfV5K6BWjibCVwzJE3GYfmAHNzk+aU05M0xEdrfZmzPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgfV5K6BWjibCVwzJE3GYfmAHNzk+aU05M0xEdrfZmzPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/26, Michael Kerrisk (man-pages) wrote:
> Hi Richard
> 
> On Mon, May 26, 2014 at 6:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 14/05/22, Michael Kerrisk wrote:
> >> Richard,
> >
> > Hi Michael,
> >
> >> On Tue, May 20, 2014 at 3:12 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > The purpose is to track namespaces in use by logged processes from the
> >> > perspective of init_*_ns.
> >> >
> >> > 1/6 defines a function to generate them and assigns them.
> >> >
> >> > Use a serial number per namespace (unique across one boot of one kernel)
> >> > instead of the inode number (which is claimed to have had the right to change
> >> > reserved and is not necessarily unique if there is more than one proc fs).  It
> >> > could be argued that the inode numbers have now become a defacto interface and
> >> > can't change now, but I'm proposing this approach to see if this helps address
> >> > some of the objections to the earlier patchset.
> >> >
> >> > 2/6 adds access functions to get to the serial numbers in a similar way to
> >> > inode access for namespace proc operations.
> >> >
> >> > 3/6 implements, as suggested by Serge Hallyn, making these serial numbers
> >> > available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
> >> > instead of "seq" for consistency with inum and there are a number of other uses
> >> > of "seq" in the namespace code.
> >> >
> >> > 4/6 exposes proc's ns entries structure which lists a number of useful
> >> > operations per namespace type for other subsystems to use.
> >>
> >> Since the 3 and 4 change the ABI, please CC iterations of this patch
> >> series to linux-api@vger.kernel.org, as per Documentation/SubmitChecklist.
> >
> > Neither patch 3/6 nor 4/6 changes the syscall interface.
> 
> (Agreed.)
> 
> > Patch 3/6 adds /proc/<pid>/ns/ entries, which looks more like #16 in
> > that document (for which /proc/<pid>/ns/<nstype> was never added).
> 
> But, that's a change to the surface that the kernel exposes to user
> space, right? If so, it is best CCed to linux-api.

Got it.  Thanks!

> Thanks,
> 
> Michael

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
