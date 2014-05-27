Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaE0K1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:27:34 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:64276 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaE0K1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:27:31 -0400
Date: Tue, 27 May 2014 14:27:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [linux-next] splice call weird results
Message-ID: <20140527102728.GD20436@moon>
References: <20140527091335.GC20436@moon>
 <20140527102013.3BF61E009B@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527102013.3BF61E009B@blue.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 01:20:13PM +0300, Kirill A. Shutemov wrote:
> Cyrill Gorcunov wrote:
> > Hi! While been trying to run criu on linux-next (due to recent Kirill's patch related
> > to /proc/pid/clear_refs with THP enabled) I noticed that it fails dumping programs when
> > moves data from memory pages into an image file. So I wrote pretty idiotic test and
> > run it on current fedora 20 kernel and then on linux-next.
> > 
> 
> +Al. He reworked splice code in linux-next.

Thanks Kirill. Al, it looks like iter_file_splice_write no longer honor @len while
building kiocb vector but pushes as much as it can.
