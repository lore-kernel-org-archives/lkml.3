Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238AbaH0Rrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:47:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38853 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbaH0Rrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:47:48 -0400
Date: Wed, 27 Aug 2014 10:47:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org
Subject: Re: [PATCH v3 part1 0/4] Fix SG_IO ambiguity between READ SUBCHANNEL
 and UNMAP (and other similar cases)
Message-ID: <20140827174746.GA18373@infradead.org>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
 <20140827093437.GA10937@hercules>
 <53FDAE65.3080208@redhat.com>
 <20140827120806.GF10937@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827120806.GF10937@hercules>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:08:06PM +0100, Luis Henriques wrote:
> Thanks a lot for the update, Paolo.
> 
> This is what I was actually expecting, although it's somewhat
> surprising, taking into account this is a security issue :-)

The right fix is to get rid of all the whitelisting BS and just allow
SG_IO if capable, not based on ownership checks.

With this all the problems with trying to work around the different commands
sets are gone.
