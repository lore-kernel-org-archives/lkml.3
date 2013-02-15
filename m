Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3BOWqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:46:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3BOWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:46:30 -0500
Date: Fri, 15 Feb 2013 14:46:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Glauber Costa <glommer@parallels.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] ia64: rename cache_show to topology_cache_show
Message-Id: <20130215144629.be18bae9.akpm@linux-foundation.org>
In-Reply-To: <1360931904-5720-1-git-send-email-mhocko@suse.cz>
References: <511e236a.o0ibbB2U8xMoURgd%fengguang.wu@intel.com>
	<1360931904-5720-1-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 13:38:24 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Fenguang Wu has reported the following compile time issue
> arch/ia64/kernel/topology.c:278:16: error: conflicting types for 'cache_show'
> include/linux/slab.h:224:5: note: previous declaration of 'cache_show' was here
> 
> which has been introduced by 749c5415 (memcg: aggregate memcg cache
> values in slabinfo). Let's rename ia64 local function to prevent from
> the name conflict.

Confused.  Tony fixed this ages ago?

: commit 4fafc8c21487f6b5259d462e9bee98661a02390d
: Author: Tony Luck <tony.luck@intel.com>
: Date:   Wed Nov 7 15:51:04 2012 -0800
: 
:     [IA64] Resolve name space collision for cache_show()
:     
:     We have a local static function named rather generically
:     "cache_show()". Changes in progress in the slab code want
:     to use this same name globally - so they are adding their
:     declaration to <linux/slab.h> which then causes the compiler
:     to choke with:
:     
:     arch/ia64/kernel/topology.c:278: error: conflicting types for 'cache_show'
:     
:     Fix by adding an "ia64_" prefix to our local function.


