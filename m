Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966479AbaFRNOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:14:55 -0400
Received: from fieldses.org ([174.143.236.118]:49515 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966306AbaFRNOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:14:53 -0400
Date: Wed, 18 Jun 2014 09:14:52 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
Message-ID: <20140618131452.GB17790@fieldses.org>
References: <20140617223854.GC6168@fieldses.org>
 <53A15684.9000002@suse.cz>
 <20140618122029.GA17790@fieldses.org>
 <53A18712.6030907@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A18712.6030907@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:33:22PM +0200, Michal Marek wrote:
> Dne 18.6.2014 14:20, J. Bruce Fields napsal(a):
> > On Wed, Jun 18, 2014 at 11:06:12AM +0200, Michal Marek wrote:
> >> Dne 18.6.2014 00:38, J. Bruce Fields napsal(a):
> >>> The changelog there says
> >>>
> >>> 	The main Makefile sets its working directory to the object tree
> >>> 	and never changes it again. Therefore, we can use '.' instead of
> >>> 	the absolute path.
> >>>
> >>> But the main Makefile also exports objtree, and a quick grep suggests
> >>> lots of other uses outside the main Makefile.
> >>
> >> Do you have examples? Besides your report, I'm only aware of make
> >> deb-pkg and make *docs. What else?
> > 
> > I haven't looked.
> > 
> > I only note that grep finds 47 files referencing that variable, and
> > absent some argument that the remaining ones are correct, I'd be
> > inclined to revert.
> 
> Do these 47 files change the working directory before referencing the
> variable?

Sorry, I'm not volunteering to check.

Note also that other variables are defined in terms of objtree, and they
may be exported or passed to other scripts.

--b.
