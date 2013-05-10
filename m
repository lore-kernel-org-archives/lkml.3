Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3EJJJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:09:35 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:46333 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3EJJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:09:31 -0400
Date: Fri, 10 May 2013 11:09:24 +0200
From: Robert Richter <rric@kernel.org>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH] perf tools: Fix perf version generation
Message-ID: <20130510090924.GB8356@rric.localhost>
References: <1368006214-12912-1-git-send-email-rric@kernel.org>
 <518A2B4B.4040509@linux.vnet.ibm.com>
 <20130508110611.GA8356@rric.localhost>
 <518A5A9D.8090503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A5A9D.8090503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.13 22:01:01, Runzhen Wang wrote:
> # ./perf --version
> perf version 3.9.1
> 
> your patch works when the repo only has commit info but no tags
> info, but I confuse that whether this situation is Real?
> 
> Maybe you prepare for a RARE case but increase the code's **Complexity** ?

It works in both cases. And the complexity is also handled for kernel
versioning, see scripts/setlocalversion:

 # If we don't have a tag at all we print -g{commitish}.

I also considered to reuse scripts/setlocalversion, but it turned out
to require too much changes for perf version generation.

-Robert
