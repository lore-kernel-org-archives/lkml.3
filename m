Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab3DHU5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:57:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965180Ab3DHU5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:57:40 -0400
Date: Mon, 8 Apr 2013 13:57:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v8 3/3] mm: reinititalise user and admin reserves if
 memory is added or removed
Message-Id: <20130408135739.a373580e624def371b542df5@linux-foundation.org>
In-Reply-To: <20130408190738.GC2321@localhost.localdomain>
References: <20130408190738.GC2321@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013 15:07:38 -0400 Andrew Shewmaker <agshew@gmail.com> wrote:

> This patch alters the admin and user reserves of the previous patches 
> in this series when memory is added or removed.
> 
> If memory is added and the reserves have been eliminated or increased above
> the default max, then we'll trust the admin.
> 
> If memory is removed and there isn't enough free memory, then we
> need to reset the reserves.
> 
> Otherwise keep the reserve set by the admin.
> 
> The reserve reset code is the same as the reserve initialization code.
> 
> Does this sound reasonable to other people? I figured that hot removal
> with too large of memory in the reserves was the most important case 
> to get right.
> 
> I tested hot addition and removal by triggering it via sysfs. The reserves 
> shrunk when they were set high and memory was removed. They were reset 
> higher when memory was added again.

I have added your Signed-off-by: to my copy of this patch.
