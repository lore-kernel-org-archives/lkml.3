Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaHSLCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:02:42 -0400
Received: from 8bytes.org ([81.169.241.247]:43805 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaHSLCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:02:41 -0400
Date: Tue, 19 Aug 2014 13:02:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
Message-ID: <20140819110239.GA16329@8bytes.org>
References: <1408352352-14449-1-git-send-email-zhen-hual@hp.com>
 <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net>
 <20140818232328.GK9809@8bytes.org>
 <1267BB84A242B24E81E0C0C8955CFFC061A4CA69@G9W0343.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267BB84A242B24E81E0C0C8955CFFC061A4CA69@G9W0343.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:27:01PM +0000, Li, Zhen-Hua wrote:
> : [fault reason 01] Present bit in root entry is clear
> It appears when iommu initializing in the kdump kernel.

Hmm, do you have an explanation how this can happen? From how I read the
code, the kdump kernel disables translation on the IOMMU, then sets a
new root entry, and then re-enabled translation. To me it looks like
there is no point in time where translation is enabled and the
root-entry is clear (present-bit==0).

But obviously I am missing something if you see the message above.

Btw, have you looked into this patch-set posted earlier this year:

	https://lkml.org/lkml/2014/4/24/836

It approaches the same problem-space, but also cares about in-flight
DMA.


	Joerg

