Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3BGLQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:16:23 -0500
Received: from multi.imgtec.com ([194.200.65.239]:38718 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGLQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:16:20 -0500
Message-ID: <51138CFC.9000508@imgtec.com>
Date: Thu, 7 Feb 2013 11:16:12 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next build conflict between modules and metag trees (LOCKDEP_NOW_UNRELIABLE)
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_07_11_16_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

The metag architecture tree adds an add_taint(TAINT_DIE) like other
architectures do, and the modules-next tree adds the
LOCKDEP_NOW_UNRELIABLE flag to all uses of add_taint (but obviously
misses arch/metag since it doesn't exist yet), causing a compile error
on metag in -next when the two are merged together.

Is it okay for me to merge your commit 373d4d0 ("taint: add explicit
flag to show whether lock dep is still OK.") in modules-next into the
base of the metag tree and expect it not to be rebased, so that I can
then squash the fix into the metag tree?

The only commits this would include are:
$ git log --oneline linus/master..373d4d0
373d4d0 taint: add explicit flag to show whether lock dep is still OK.
64748a2 module: printk message when module signature fail taints kernel.

Thanks
James

