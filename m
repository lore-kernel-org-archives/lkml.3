Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3DJFwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:52:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53994 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3DJFwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:52:15 -0400
Date: Tue, 9 Apr 2013 22:52:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v2 0/3] Support memory hot-delete to boot memory
In-Reply-To: <1365454703.32127.8.camel@misato.fc.hp.com>
Message-ID: <alpine.DEB.2.02.1304092155220.25293@chino.kir.corp.google.com>
References: <1365440996-30981-1-git-send-email-toshi.kani@hp.com> <20130408134438.2a4388a07163e10a37158eed@linux-foundation.org> <1365454703.32127.8.camel@misato.fc.hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, Toshi Kani wrote:

> > So we don't need this new code if CONFIG_MEMORY_HOTPLUG=n?  If so, can
> > we please arrange for it to not be present if the user doesn't need it?
> 
> Good point!  Yes, since the new function is intended for memory
> hot-delete and is only called from __remove_pages() in
> mm/memory_hotplug.c, it should be added as #ifdef CONFIG_MEMORY_HOTPLUG
> in PATCH 2/3.
> 
> I will make the change, and send an updated patch to PATCH 2/3.
> 

It should actually depend on CONFIG_MEMORY_HOTREMOVE, but the pseries 
OF_RECONFIG_DETACH_NODE code seems to be the only code that doesn't 
make that distinction.  CONFIG_MEMORY_HOTREMOVE acts as a wrapper to 
protect configs that don't have ARCH_ENABLE_MEMORY_HOTREMOVE, so we'll 
want to keep it around and presumably that powerpc code depends on it as 
well.
