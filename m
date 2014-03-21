Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbaCUMrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:47:01 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54561 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392AbaCUMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:47:00 -0400
X-Hashcash: 1:20:140321:david.woodhouse@intel.com::d7JphP95RFRyKTxo:00000000000000000000000000000000000090iK
X-Hashcash: 1:20:140321:linux-kernel@vger.kernel.org::BgPD3+0iC+Pae29W:0000000000000000000000000000000000G0b
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Comment added in 63662139e "params: Fix potential memory leak in add_sysfs_param()"
Organization: D03
Date: Fri, 21 Mar 2014 13:46:56 +0100
Message-ID: <878us367nj.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not at all convinced by the comment added in commit
63662139e519ce. If krealloc(attrs, ...) fails, nothing seems to free attrs;
the krealloc() call certainly doesn't do it. If attrs was NULL to begin
with, no harm done, but otherwise it is "attrs = mk->mp->grp.attrs;",
and mk->mp is NULL'ed on the error path fail_free_new: (and the value of
mk->mp is anyway invalidated by the krealloc() above).

Am I missing something?

Rasmus
