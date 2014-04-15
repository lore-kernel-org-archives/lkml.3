Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaDOQtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:49:15 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:40537
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbaDOQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:49:12 -0400
Date: Tue, 15 Apr 2014 11:49:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Marek <mmarek@suse.cz>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <534D4A59.6080401@suse.cz>
Message-ID: <alpine.DEB.2.10.1404151146530.26562@gentwo.org>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Michal Marek wrote:

> I fail to see how the above commit is responsible for this. make install
> starts /sbin/installkernel and the rest is the job of this script. To
> me, it looks more like a fakeroot failure than a bug in make install.

The problem is that the kernel build process should not write to anything
in the /etc/apt directory. fakeroot only fakes root. Writing files may
occur to the users homedirectory (where the kernel build tree is) but not
to directories where the user running fakeroot has no write access.

I have the same issue here. Lets see if reverting that commit fixes it.

