Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab3AOSmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:42:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab3AOSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:42:52 -0500
Date: Tue, 15 Jan 2013 16:42:45 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [ 19/49] NFSv4: Add ACCESS operation to OPEN compound
Message-ID: <20130115184244.GB3408@herton-Z68MA-D2H-B3>
References: <20130113174255.736888844@decadent.org.uk>
 <20130113174259.796403049@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130113174259.796403049@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 05:43:14PM +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Weston Andros Adamson <dros@netapp.com>
> 
> commit 6168f62cbde8dcf4f58255794efbcdb8df603959 upstream.
> 
> The OPEN operation has no way to differentiate an open for read and an
> open for execution - both look like read to the server. This allowed
> users to read files that didn't have READ access but did have EXEC access,
> which is obviously wrong.
> 
> This patch adds an ACCESS call to the OPEN compound to handle the
> difference between OPENs for reading and execution.  Since we're going
> through the trouble of calling ACCESS, we check all possible access bits
> and cache the results hopefully avoiding an ACCESS call in the future.
> 
> Signed-off-by: Weston Andros Adamson <dros@netapp.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - #include <linux/export.h> in fs/nfs/dir.c]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

This 3.2 series lacks commit ae2bb03236fc978bdf673c19d39832500793b83c
pointed in its changelog as fixing a regression from this one.

-- 
[]'s
Herton
