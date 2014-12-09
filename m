Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaLIIrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:47:17 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57427 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaLIIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:47:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Keith Busch <keith.busch@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH] misc: Increase available dyanmic minors
Date: Tue, 09 Dec 2014 09:46:36 +0100
Message-ID: <3419037.dh84oOupWY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418079710-30968-1-git-send-email-keith.busch@intel.com>
References: <1418079710-30968-1-git-send-email-keith.busch@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:sZZkoReGyrvoRyRq9Zw8TEMj5LLUhKhgu2k6fjaIl2nMCX23PE9
 /ESlRmfnJQJ+lr11B4x88RiBlLwLdg0JsxCg8FiLPaiUQkxp5OihhrJxlXHxNZEYsHpYjZR
 u7rXUh6lrmODJkFmDPLv1gamiYfojm/R2ExZeBrN7lYAMPAGm+CxRy5SUdKycug4ol6ESbM
 OVm7vVh4iqYi8tDKvBLcw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 16:01:50 Keith Busch wrote:
> This increases the number of available miscellaneous character device
> dynamic minors from 63 to the max minor, 1M.
> 
> Dynamic minor previously started at 63 and went down to zero. That's not
> enough in some situations, and also eventually creates a collision with
> 'psaux' misc device. This patch starts minors at the last defined misc
> minor (255) and works up to the max possible.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>

I guess this will break support for ancient user space tools, and
possibly also old file systems that do not support more than 8-bit
minor numbers. I would assume that it's ok, but you definitely have
to mention in the changelog that things might break and how you
have concluded that this is safe enough.

If you cannot come up with a good reasoning, it might be better
to combine both and use up the traditional dynamic minor numbers
before using the >255 range.

	Arnd
