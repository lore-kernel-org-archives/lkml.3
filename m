Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBYI5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:57:06 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60616 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaBYI5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:57:02 -0500
Date: Tue, 25 Feb 2014 09:56:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tom Rini <trini@ti.com>
Cc: Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
Message-ID: <20140225085657.GA4746@osiris>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
 <1393275606.11020.59.camel@joe-AO722>
 <530BB571.8080509@ti.com>
 <1393277304.11020.64.camel@joe-AO722>
 <530BBF10.6050601@ti.com>
 <1393279377.11020.66.camel@joe-AO722>
 <530BC209.2000708@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530BC209.2000708@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022508-5024-0000-0000-000008DD8392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 05:04:57PM -0500, Tom Rini wrote:
> On 02/24/2014 05:02 PM, Joe Perches wrote:
> > On Mon, 2014-02-24 at 16:52 -0500, Tom Rini wrote:
> >> I've been lead to
> >> believe that most cases now people should be using regmap instead, which
> >> just leaves the case of having to match on-disk formats or similar cases
> >> I believe as the things that must stay __packed.
> > 
> > __packed is also necessary for on-wire networking protocols.
> 
> Indeed, and there's probably a few other valid cases I'm also
> forgetting.  But the common case is hardware, where regmap is now preferred.

Except on s390 which doesn't use regmap. So this will give us a lot of false
positives with a warning message that isn't helpful at all.
It doesn't even tell us why it could be problematic and what would be the
better choice.
 
> I've got this modified to a CHK and only for non-file usage.  Anything
> else we want to talk about before I repost?

/me thinks this patch should be dropped. It would cause too many false
positives, since there are lot of valid use cases for __packed.

