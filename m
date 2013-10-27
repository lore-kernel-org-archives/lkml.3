Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3J0MaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:30:13 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60593 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3J0MaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:30:12 -0400
Date: Sun, 27 Oct 2013 08:30:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131027123008.GJ14934@mtj.dyndns.org>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:58:11PM +0800, Wei Yang wrote:
> When a cpu belongs to a new group, there is no cpu has the same group id. This
> means it can be assigned a new group id without checking with every others.
> 
> This patch does this optimiztion.

Does this actually matter?  If so, it'd probably make a lot more sense
to start inner loop at @cpu + 1 so that it becomes O(N).

Thanks.

-- 
tejun
