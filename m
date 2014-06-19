Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbaFSIa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:30:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbaFSIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:30:55 -0400
Date: Thu, 19 Jun 2014 01:30:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: fix errors caused by objtree redefinition
Message-ID: <20140619083047.GB24952@birch.djwong.org>
References: <20140619001305.GA24952@birch.djwong.org>
 <53A290EC.1000202@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A290EC.1000202@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:27:40AM +0200, Michal Marek wrote:
> On 2014-06-19 02:13, Darrick J. Wong wrote:
> > In commit 7e1c04779efd51154baf652e653ceb24ce68939b ("kbuild: Use
> > relative path for $(objtree)"), objtree was redefined from whatever
> > $(CURDIR) is to a simple ".".  Unfortunately, this breaks builddeb,
> > which was relying on $objtree to be an absolute path, not a relative
> > one.  Since the script is run from the object directory, pick up a
> > more absolute value for objtree where it's needed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scripts/package/builddeb |    1 +
> >  1 file changed, 1 insertion(+)
> 
> Hi Darrick,
> 
> thanks for the patch. Can you check if commit a765a7ce from linux-next
> also fixes your issue? This is on its way to Linus.

Looks good!  You can add my Tested-by if you like.

--D
> 
> Thanks,
> Michal
