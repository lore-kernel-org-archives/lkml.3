Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaDHKuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:50:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58911 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbaDHKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:50:18 -0400
Date: Tue, 8 Apr 2014 06:49:59 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Gerhard Sittig <gsi@denx.de>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Hans-Bernhard =?iso-8859-1?Q?Br=F6ker?= 
	<broeker@users.sourceforge.net>,
        linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@users.sourceforge.net>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>
Subject: Re: cscope: issue with symlinks in
 tools/testing/selftests/powerpc/copyloops/
Message-ID: <20140408104959.GA26003@hmsreliant.think-freely.org>
References: <1396530975.4361.28.camel@localhost.localdomain>
 <20140407104216.GB5287@hmsreliant.think-freely.org>
 <20140407124259.GZ11339@book.gsilab.sittig.org>
 <20140408075610.GJ11339@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408075610.GJ11339@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:56:10AM +0200, Gerhard Sittig wrote:
> [ removed cscope-devel from Cc:, non-subscriber mails get blocked anyway ]
> 
> On Mon, 2014-04-07 at 14:42 +0200, Gerhard Sittig wrote:
> > 
> > On Mon, 2014-04-07 at 06:42 -0400, Neil Horman wrote:
> > > 
> > > On Thu, Apr 03, 2014 at 03:16:15PM +0200, Yann Droneaud wrote:
> > > > 
> > > > [ ... ]
> > > > 
> > > > cscope reports error when generating the cross-reference database:
> > > > 
> > > >     $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
> > > >       GEN     cscope
> > > >     cscope: cannot find
> > > > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
> > > >     cscope: cannot find
> > > > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_64.S
> > > >     cscope: cannot find
> > > > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
> > > >     cscope: cannot find
> > > > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_64.S
> > > > 
> > > > And when calling cscope from ./obj-cscope/ directory, it reports errors
> > > > too.
> > > > 
> > > > Hopefully it doesn't stop it from working, so I'm still able to use
> > > > cscope to browse kernel sources.
> > > > 
> > > No, it won't stop it from working, it just won't search those files.  I don't
> > > recall exactly the reason, but IIRC there was a big discussion long ago about
> > > symlinks and our ability to support them (around version 1.94 I think).  We
> > > decided to not handle symlinks, as they would either point outside our search
> > > tree, which we didn't want to include, or would point to another file in the
> > > search tree, which made loading them pointless (as we would cover the search in
> > > the pointed file).
> > 
> > So there are valid reasons to not process those filesystem
> > entries.  Would it be useful to not emit the warnings then?  Or
> > to silent those warnings when the user knows it's perfectly legal
> > to skip those filesytem entries?  Like what you can do with the
> > ctags(1) command and its --links option.
> 
> For the record:  I got a response "off list" (actually to the
> cscope list only which is closed for non-subscribers, while the
> Linux related recipients were removed despite the fact that the
> issue appears to be in Linux), see
> http://article.gmane.org/gmane.comp.programming.tools.cscope.devel/105
> 
I don't agree with Hans here. He's right in that the Linux makefiles could
exclude the symlinks from the index file that it builds, but if cscope were left
to its own devices it would also exclude the assembly files and other code that
it doesn't officially parse, but does more or less ok with.  We can argue all
day weather its ok for Linux to do that, but the facts of the matter is that
people use cscope  to search the linux source tree asm files and all, and while
we could propose that the cscope makefile target filter out symlinks, it seems
IMHO to be more difficult than its worth.  Adding code to silence db build
warnings would be good.

> This reponse suggests that the issue is not in cscope(1) itself,
> but instead is in how the cscope(1) command got invoked.  Which
> translates into "the Linux infrastructure does something wrong".
> 
> A quick search identifies ./scripts/tags.sh:all_target_sources()
> as the spot where symlinks should get filtered out.  Where both
> paths of all_target_sources() end up calling all_sources().
> 
> 
> virtually yours
> Gerhard Sittig
> -- 
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
> Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
> 
