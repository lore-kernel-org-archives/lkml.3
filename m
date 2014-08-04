Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaHDOlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:41:13 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36006 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaHDOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:41:12 -0400
Date: Mon, 4 Aug 2014 10:43:20 -0400
From: "Devin J. Pohly" <djpohly@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kbuild: use $(srctree) to locate config headers from
 external modules
Message-ID: <20140804144320.GA4379@chiri>
References: <1406922443-22770-1-git-send-email-djpohly+linux@gmail.com>
 <53DF944C.2090207@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF944C.2090207@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 04:10:20PM +0200, Michal Marek wrote:
> include/generated is located in $(KBUILD_OUTPUT), which is different
> from $(srctree) when using O=. Can you post a sequence of commands that
> leads to the error you are seeing?
> 
> Thanks,
> Michal

Well, I was attempting to do something like this:

$ make -C $KDIR M=$PWD modules
$ make -C $KDIR M=$PWD O=$pkgdir modules_install

... but I your statement just made the problem really obvious: I don't
need to be using O= at all in this case.  Duh.

$ make -C $KDIR M=$PWD modules
$ make -C $KDIR M=$PWD INSTALL_MOD_PATH=$pkgdir modules_install

works as expected, and the only patch needed was to my brain. :)  Mea
culpa.

*dp

