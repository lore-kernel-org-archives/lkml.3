Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3AJUCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:02:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37853 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3AJUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:02:28 -0500
Date: Thu, 10 Jan 2013 21:02:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-acpi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, zeus@gnu.org,
        linux-kernel@vger.kernel.org
Subject: Re: srat: harsh hot-pluggable memory check?
Message-ID: <20130110200223.GH30577@one.firstfloor.org>
References: <1357846907.7523.17.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357846907.7523.17.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This only mentions that the system supports hot-plugging, and IMHO if the
> user decides not to use CONFIG_MEMORY_HOTPLUG, it shouldn't be considered an error.
> Therefore would it be ok to drop the check? Or am I missing something?

The very strict checks were originally implemented because various early
BIOS had largely fictional SRATs, and trusting them blindly caused
boot failures or a lot of wasted memory for unnecessary hotplug zones. 
The wasted memory was mainly a problem with the old memory hotplug
implementation that pre-allocated memmaps, that's not a problem anymore.
However there may be still some other failure cases.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
