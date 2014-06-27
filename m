Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaF0JIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:08:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:51278 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaF0JI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:08:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,559,1400050800"; 
   d="scan'208";a="564385201"
Message-ID: <1403860094.3954.6.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: =?ISO-8859-1?Q?Luk=E1=3F?= Czerner <lczerner@redhat.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Dave Chinner <david@fromorbit.com>,
        Thomas Knauth <thomas.knauth@gmx.de>,
        David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 27 Jun 2014 12:08:14 +0300
In-Reply-To: <20140627084139.GA29704@citd.de>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	 <20140626010606.GT4453@dastard>
	 <1403763199.20275.39.camel@sauron.fi.intel.com>
	 <53ABF7C4.1000906@itwm.fraunhofer.de>
	 <1403782263.20275.59.camel@sauron.fi.intel.com>
	 <alpine.LFD.2.00.1406261349320.2172@localhost.localdomain>
	 <20140627084139.GA29704@citd.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 10:41 +0200, Matthias Schniedermeyer wrote:
> On 26.06.2014 13:57, Luká? Czerner wrote:
> 
> > > So if the authors want to sell this new interface (in whatever form) to
> > > the kernel community, they should start with providing a solid use-case,
> > > with some more details, explore alternatives and show how the
> > > alternatives do not work for them.
> > 
> > Yes please, let's see some solid use-case for this.
> 
> Personally i would want it to verify files after copying them:
> Especially while moving files:
> - Copy a file
> - <drop cache>
> - Verify that it really is correct on stable storage
> - Remove original file

To make 100% sure you'd not only need to drop VFS-level caches but also
file-system-level caches. Indeed, file-systems have their own rather
buffers for different indexing data-structures, etc. The unmount/mount
sequence takes care of that.

-- 
Best Regards,
Artem Bityutskiy

