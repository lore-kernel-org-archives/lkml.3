Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaDGMnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:43:19 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51517 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbaDGMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:43:07 -0400
X-Auth-Info: qynNwqG2RV5XUqpSuHsp70DDYgWYxsdT5HcLMTnEqtw=
Date: Mon, 7 Apr 2014 14:42:59 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Hans-Bernhard =?iso-8859-1?Q?Br=F6ker?= 
	<broeker@users.sourceforge.net>,
        linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@users.sourceforge.net>,
        cscope-devel@lists.sourceforge.net, Anton Blanchard <anton@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>
Subject: Re: cscope: issue with symlinks in
 tools/testing/selftests/powerpc/copyloops/
Message-ID: <20140407124259.GZ11339@book.gsilab.sittig.org>
References: <1396530975.4361.28.camel@localhost.localdomain>
 <20140407104216.GB5287@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407104216.GB5287@hmsreliant.think-freely.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 06:42 -0400, Neil Horman wrote:
> 
> On Thu, Apr 03, 2014 at 03:16:15PM +0200, Yann Droneaud wrote:
> > 
> > [ ... ]
> > 
> > cscope reports error when generating the cross-reference database:
> > 
> >     $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
> >       GEN     cscope
> >     cscope: cannot find
> > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
> >     cscope: cannot find
> > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_64.S
> >     cscope: cannot find
> > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
> >     cscope: cannot find
> > file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_64.S
> > 
> > And when calling cscope from ./obj-cscope/ directory, it reports errors
> > too.
> > 
> > Hopefully it doesn't stop it from working, so I'm still able to use
> > cscope to browse kernel sources.
> > 
> No, it won't stop it from working, it just won't search those files.  I don't
> recall exactly the reason, but IIRC there was a big discussion long ago about
> symlinks and our ability to support them (around version 1.94 I think).  We
> decided to not handle symlinks, as they would either point outside our search
> tree, which we didn't want to include, or would point to another file in the
> search tree, which made loading them pointless (as we would cover the search in
> the pointed file).

So there are valid reasons to not process those filesystem
entries.  Would it be useful to not emit the warnings then?  Or
to silent those warnings when the user knows it's perfectly legal
to skip those filesytem entries?  Like what you can do with the
ctags(1) command and its --links option.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
