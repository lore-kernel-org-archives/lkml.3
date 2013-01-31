Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3AaX7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:59:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:59:41 -0500
Date: Thu, 31 Jan 2013 15:59:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/6] fs: Take mapping lock in generic read paths
Message-Id: <20130131155940.7b1f8e0e.akpm@linux-foundation.org>
In-Reply-To: <1359668994-13433-3-git-send-email-jack@suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
	<1359668994-13433-3-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 22:49:50 +0100
Jan Kara <jack@suse.cz> wrote:

> Add mapping lock to struct address_space and grab it in all paths
> creating pages in page cache to read data into them. That means buffered
> read, readahead, and page fault code.

Boy, this does look expensive in both speed and space.

As you pointed out in [0/n], it's 2-3%.  As always with pagecache
stuff, the cost of filling the page generally swamps any inefficiencies
in preparing that page.

