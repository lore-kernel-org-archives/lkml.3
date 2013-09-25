Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3IYN7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:59:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35753 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3IYN7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:59:35 -0400
Date: Wed, 25 Sep 2013 08:59:32 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Copy on write hard links?
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
In-Reply-To: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de> (from
	thomas@m3y3r.de on Tue Sep 24 13:36:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380117572.1974.81@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 01:36:56 PM, Thomas Meyer wrote:
> Hi,
> 
> Is there such a thing?

In the kernel's vfs layer? No, although some filesystems (ala btrfs) do  
things like that with snapshots.

In userspace? Breaking hardlinks when updating a file is fairly normal,  
that's why they distinguish between "truncate and rewrite" (preserve  
hardlinks) and "write new file and rename over old file" (break  
hardlinks, avoiding the more obvious race conditions).

Rob