Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3KJPXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:23:42 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54427 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3KJPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:23:41 -0500
Date: Sun, 10 Nov 2013 16:23:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Mario <jmario@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [kallsyms] general protection fault: 0000 [#1] PREEMPT
 DEBUG_PAGEALLOC
Message-ID: <20131110152338.GN29695@two.firstfloor.org>
References: <20131110094005.GA21916@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110094005.GA21916@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 05:40:05PM +0800, Fengguang Wu wrote:
> Hi Joe,
> 
> FYI. Here is another bisect result.

I bet it's that strncpy() in kallsyms.c and someone passing in a too
short buffer on a 32bit kernel.

We should really kill strncpy(), it's just evil.

-And
