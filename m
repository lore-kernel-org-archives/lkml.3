Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3DQBBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:01:18 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49704 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3DQBBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:01:15 -0400
Date: Tue, 16 Apr 2013 18:01:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-scsi@vger.kernel.org,
        Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/28] proc: Supply an accessor for getting the data from
 a PDE's parent [RFC]
Message-ID: <20130417010104.GF11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182646.27773.40149.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182646.27773.40149.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:46PM +0100, David Howells wrote:
> Supply an accessor function for getting the private data from the parent
> proc_dir_entry struct of the proc_dir_entry struct associated with an inode.
> 
> ReiserFS, for instance, stores the super_block pointer in the proc directory
> it makes for that super_block, and a pointer to the respective seq_file show
> function in each of the proc files in that directory.
> 
> This allows a reduction in the number of file_operations structs, open
> functions and seq_operations structs required.  The problem otherwise is that
> each show function requires two pieces of data but only has storage for one
> per PDE (and this has no release function).
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> cc: linux-wireless@vger.kernel.org
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
