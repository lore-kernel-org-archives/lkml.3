Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbaKMVvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:51:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424AbaKMVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:51:42 -0500
Date: Thu, 13 Nov 2014 21:51:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pieter Smith <pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/56] fs: Macros to define splice file_operations
Message-ID: <20141113215139.GK7996@ZenIV.linux.org.uk>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-5-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415913813-362-5-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:22:41PM +0100, Pieter Smith wrote:
> Provides a CONFIG_SYSCALL_SPLICE compatible way of defining the .splice_read
> and .splice_write file_operations so that they can later be compiled out when
> the kernel is configured without the splice-family syscalls

This (and subsequent stuff making use of that) is bloody pointless.  You
save 2 words per file_operations instance, at the cost of making things
uglier and harder to grep.  NAK.
