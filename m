Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaKXPDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:03:49 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:39567 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaKXPDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:03:48 -0500
Date: Mon, 24 Nov 2014 17:03:42 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/thp: Always allocate transparent hugepages on
 local node
Message-ID: <20141124150342.GA3889@node.dhcp.inet.fi>
References: <1416838791-30023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416838791-30023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:49:51PM +0530, Aneesh Kumar K.V wrote:
> This make sure that we try to allocate hugepages from local node. If
> we can't we fallback to small page allocation based on
> mempolicy. This is based on the observation that allocating pages
> on local node is more beneficial that allocating hugepages on remote node.

Local node on allocation is not necessary local node for use.
If policy says to use a specific node[s], we should follow.

I think it makes sense to force local allocation if policy is interleave
or if current node is in preferred or bind set.
 
-- 
 Kirill A. Shutemov
