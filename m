Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaF0ItP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:49:15 -0400
Received: from awesome.dsw2k3.info ([217.188.63.246]:33954 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaF0ItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:49:12 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 04:49:12 EDT
Date: Fri, 27 Jun 2014 10:41:39 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: =?iso-8859-1?B?THVr4T8=?= Czerner <lczerner@redhat.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Dave Chinner <david@fromorbit.com>,
        Thomas Knauth <thomas.knauth@gmx.de>,
        David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
Message-ID: <20140627084139.GA29704@citd.de>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
 <1403677528.7903.103.camel@sauron.fi.intel.com>
 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
 <20140626010606.GT4453@dastard>
 <1403763199.20275.39.camel@sauron.fi.intel.com>
 <53ABF7C4.1000906@itwm.fraunhofer.de>
 <1403782263.20275.59.camel@sauron.fi.intel.com>
 <alpine.LFD.2.00.1406261349320.2172@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1406261349320.2172@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.2014 13:57, Luká? Czerner wrote:

> > So if the authors want to sell this new interface (in whatever form) to
> > the kernel community, they should start with providing a solid use-case,
> > with some more details, explore alternatives and show how the
> > alternatives do not work for them.
> 
> Yes please, let's see some solid use-case for this.

Personally i would want it to verify files after copying them:
Especially while moving files:
- Copy a file
- <drop cache>
- Verify that it really is correct on stable storage
- Remove original file

Currently i choose either of the 3 ways:
- drop_caches
- umount/mount
- Write more data than memory in machine (Which is only an 
approximnation and you have to verify in the same order the files were 
written, so it is likely that any cache was thrashed in the meantime)

But having a way to selectivly "destory" the cache of a file would make 
this task easier.




-- 

Matthias
