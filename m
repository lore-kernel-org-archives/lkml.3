Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120Ab3DJXhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:32480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762080Ab3DJXhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="225760697"
Subject: [PATCH 0/5] [RFC] rework /dev/mem code vs. highmem and DEBUG_VIRTUAL
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:49 -0700
Message-Id: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/dev/[k]mem are a bit of a mess.  They've probably been subtly
broken for a long time on highmem or when the kernel's page
tables have been munged in other ways.

This has only been lightly tested on x86.  Needs some review
and some wider testing before getting applied anywhere.
