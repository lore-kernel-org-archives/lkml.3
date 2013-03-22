Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3CWHCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 03:02:17 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:40475 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3CWHCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 03:02:16 -0400
Date: Fri, 22 Mar 2013 00:15:48 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
To: George Spelvin <linux@horizon.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux@horizon.com
In-Reply-To: <20130320194108.24192.qmail@science.horizon.com> (from
	linux@horizon.com on Wed Mar 20 14:41:08 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363929348.15703.58@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 02:41:08 PM, George Spelvin wrote:
> Sorry for being so very late to the party, but rather than messing
> with xattrs, why not just have a specific file (say, default  
> /.whiteout,
> but selectable via a mount option) and links to it are counted as
> whiteout entries?

Don't the ext2 descendants have an array of reserved inodes at the  
beginning (one of which is the journal for ext3, most of which were  
still unused last I checked)?

Maybe ext4 optimized this away, but that would mean it doesn't have to  
be anywhere in the namespace.

(Of course you'd have to teach fsck about it, and probably not update  
the link count or you'll have contention and integer overflow...)

Rob