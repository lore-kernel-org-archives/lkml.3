Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaHWPkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:40:33 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:54864 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaHWPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:40:31 -0400
Date: Sat, 23 Aug 2014 10:40:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/15] percpu: perform tlb flush after pcpu_map_pages()
 failure
In-Reply-To: <1408726399-4436-3-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.11.1408231039220.29970@gentwo.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org> <1408726399-4436-3-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Tejun Heo wrote:

> If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
> Currently, it doesn't flush tlb after the partial unmapping.  This may
> be okay in most cases as the established mapping hasn't been used at
> that point but it can go wrong and when it goes wrong it'd be
> extremely difficult to track down.

So why is this separate? You added the unmapping in the last patch without
the flushing and this is a fixup for the patch before?


