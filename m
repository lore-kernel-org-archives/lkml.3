Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaLXTLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 14:11:11 -0500
Received: from hofr.at ([212.69.189.236]:57051 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaLXTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 14:11:10 -0500
Date: Wed, 24 Dec 2014 20:11:07 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] incorrect use of init_completion fixup
Message-ID: <20141224191107.GA24476@opentech.at>
References: <1419357151-22889-1-git-send-email-der.herr@hofr.at> <549B0DA5.3010700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549B0DA5.3010700@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2014, Prarit Bhargava wrote:

> 
> 
> On 12/23/2014 12:52 PM, Nicholas Mc Guire wrote:
> > The successive init_completion calls should be reinit_completion here.
> > 
> 
> Hi Nicholas,
> 
> I know enough about this code to break it ;) ... what condition did you hit that
> led you to this patch?
>

Was writing up documentation for completion (also posted today) and the 
intended API is reinit_completion which is just resetting the counter but
not touching the related waitqueu. So the failure scenario would be
a race between accessing elements on the current wait-queue and the 
init_completion reinitializing this very wait-queue. 

Further if switching from init_completion -> reinit_completion brakes
anything then it really *is* broken now.

thx!
hofrat
