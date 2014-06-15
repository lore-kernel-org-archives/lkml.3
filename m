Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaFOQL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:11:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42927 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaFOQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:11:53 -0400
Date: Sun, 15 Jun 2014 12:11:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] fs/omfs/inode.c: use ULLONG_MAX instead of ~0ULL
Message-ID: <20140615161142.GC15404@localhost>
References: <1402814360-3122-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402814360-3122-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 08:39:20AM +0200, Fabian Frederick wrote:
> Use more explicit kernel.h definition
>  	array_size = DIV_ROUND_UP(bitmap_size, sb->s_blocksize);
>  
> -	if (sbi->s_bitmap_ino == ~0ULL)
> +	if (sbi->s_bitmap_ino == ULLONG_MAX)
>  		goto out;

So I agree they are the same, but is there a good reason for the
change?

Semantically, I think of ~0ULL as "all ones" whereas ULLONG_MAX
as a maximum of a magnitude comparison, which this is not really.

-- 
Bob Copeland %% www.bobcopeland.com
