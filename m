Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3JXQn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:43:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35140 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3JXQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:43:57 -0400
X-IronPort-AV: E=Sophos;i="4.93,563,1378857600"; 
   d="scan'208";a="64392404"
Message-ID: <1382633034.22417.121.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM
 guests.
From: Ian Campbell <ian.campbell@citrix.com>
To: Julien Grall <julien.grall@linaro.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Date: Thu, 24 Oct 2013 17:43:54 +0100
In-Reply-To: <52694B3F.5090008@linaro.org>
References: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
	 <5245FD71.3080408@linaro.org> <20130930144513.GM3106@phenom.dumpdata.com>
	 <5251CD98.70807@linaro.org> <20131023161518.GA28413@phenom.dumpdata.com>
	 <526848C1.5030705@linaro.org> <20131024144921.GB29944@phenom.dumpdata.com>
	 <52694B3F.5090008@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 17:30 +0100, Julien Grall wrote:

> I'm sure the solution "move xen call earlier" will come up in few mails, 
> so there was a discussion for swiotlb few weeks ago 
> (https://lkml.org/lkml/2013/8/29/609). And the final decision was to 
> avoid specific Xen call in arch_setup.

It wasn't so much a hard reject as a preference based on the need
presented at the time.

Perhaps a generic DT driven mechanism to detect hypervisors, called
early, would be more acceptable?

> Stefano, Ian, any opinion?

The ifdef approach is a bit ugly, but if the other option doesn't work
out I suppose we can live with it.

But stepping back how/why is this function called on x86 when not
running under Xen? Wouldn't the use have to be using console=hvc or
earlyprintk=xen or something -- which strikes me as user error... IOW
can we not just nuke the check

Ian.

