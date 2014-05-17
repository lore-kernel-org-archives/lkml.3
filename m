Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaEQDXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 23:23:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40825 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaEQDXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 23:23:44 -0400
Date: Fri, 16 May 2014 20:23:41 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/8] e1000e: Out of line __ew32_prepare/__ew32
Message-ID: <20140516202341.4b402aa6@nehalam.linuxnetplumber.net>
In-Reply-To: <1400276595-6965-5-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
	<1400276595-6965-5-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 14:43:11 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Out of lining these two common inlines saves about 30k text size,
> due to their errata workarounds.
> 
> 14131431	2008136	1507328	17646895	10d452f	vmlinux-before-e1000e
> 14101415	2004040	1507328	17612783	10cbfef	vmlinux-e1000e
> 
> Cc: jeffrey.t.kirsher@intel.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Since you are making a formerly private function global, the name
should be unique. I.e prefix it with e1000_


