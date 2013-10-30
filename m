Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3J3Mi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:38:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38500 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab3J3Mi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:38:56 -0400
Date: Wed, 30 Oct 2013 12:38:50 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: matthew.garrett@nebula.com, jk@ozlabs.org, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Subject: Re: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
Message-ID: <20131030123850.GA8193@console-pimps.org>
References: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct, at 03:37:17PM, Geyslan G. Bem wrote:
> This reorganization:
> 
> Adds 'attrsize' variable to make the code cleaner and more
> understandable, replacing all 'sizeof(attributes)'.
> 
> Removes 'bytes' prior assignment due this new approach.
> 
> Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/efivarfs/file.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)

Hmm.. I'm not convinced this is much of an improvement. I think removing
'sizeof(attributes)' actually makes the code harder to read.

-- 
Matt Fleming, Intel Open Source Technology Center
