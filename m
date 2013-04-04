Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764550Ab3DDTMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:12:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764529Ab3DDTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:12:49 -0400
Date: Thu, 4 Apr 2013 20:12:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Cotey <puff65537@bansheeslibrary.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC] drivers/staging/silicom/bp_proc.c removal
Message-ID: <20130404191245.GT21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	It's all ifdefed out (on BYPASS_SUPPORT), severely bitrotten (try
to remove the ifdef and watch what happens on attempt to build) and, AFAICS,
it's a duplicate of the stuff in bp_mod.c.

	Is there any reason to keep it around?  IOW, how about
git rm drivers/staging/silicom/bp_proc.c
git mv drivers/staging/silicom/bp{,ctl}_mod.c
ed drivers/staging/silicom/Makefile <<EOF
/bp_proc/d
wq
EOF
and if anybody needs to see what used to be there, git history is enough...

	Another thing: please, check the vfs.git patches to bp_mod.c
in linux-next.  I think they are safe, but I don't have the hardware
to test them on...
