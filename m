Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3AOX2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:28:20 -0500
Received: from csamuel.org ([74.50.50.137]:35268 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab3AOX2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:28:17 -0500
Message-ID: <50F5E5FE.9040304@csamuel.org>
Date: Wed, 16 Jan 2013 10:27:58 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, dhowells@redhat.com,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC] [PATCH] Disable INSTALL_MOD_STRIP when CONFIG_MODULE_SIG
 set
References: <50F46C36.3060403@csamuel.org>
In-Reply-To: <50F46C36.3060403@csamuel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* Please CC, not on LKML */

On 15/01/13 07:36, Chris Samuel wrote:

> So we set mod_strip_cmd to be true to prevent it stripping kernel
> modules, just as happens if INSTALL_MOD_STRIP is not passed.

Ignore this patch, sorry for the noise.

I'd tested by comparing the modules produced by the build system in this
patch with the ones produced by make-kpkg and missed the fact that
*after* doing the module install make-kpkg then runs objcopy on the
modules to copy out the debug sections for a debug package and then uses
objcopy to remove the same debug sections (along with the signature)
from the ones in the main package. :-(

I'd also misread the order that the strip and signing happens, so that
the kernel signs after stripping, so there is nothing to fix.

Interestingly stripping them only saves 1MB out of 120MB for me, so it
hardly seems worth doing.

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
