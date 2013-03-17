Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3CQSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:25:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3CQSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:25:55 -0400
Date: Sun, 17 Mar 2013 18:25:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Use file_inode()
Message-ID: <20130317182550.GD21522@ZenIV.linux.org.uk>
References: <20130317180036.GA16843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317180036.GA16843@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 07:00:36PM +0100, Oleg Nesterov wrote:
> Cleanup. Now that we have f_inode/file_inode() we can use it
> instead of ->f_mapping->host.

No.  This is *not* guaranteed to be the same thing in general; note that
e.g. for block devices ->f_mapping->host is *not* equal to file_inode().
It probably is valid in this particular case, but at the very least you
need to explain that in commit message, or soon we'll get the Knights of
Holy Commit Count(tm) crapping all over the tree, breaking stuff.
