Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3ETTjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:39:23 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:56798 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3ETTjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:39:21 -0400
Date: Mon, 20 May 2013 14:39:18 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new mount is broken w/regard to devnames in /etc/fstab
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <51985C9E.3020106@tlinx.org> (from lkml@tlinx.org on Sun May 19
	00:01:18 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369078758.2776.2@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2013 12:01:18 AM, Linda Walsh wrote:
> 1) How is one supposed to get the real root device?
> It's not /dev/root -- and on my system /dev/root doesn't even exist.

There was a thread on this a couple months ago:
   https://lkml.org/lkml/2013/3/20/315

You can get the major/minor of a filesystem with the stat() system  
call, or even the stat command line utility. That gives you the  
major/minor of the device the filesystem was mounted from.

Note that there's only a major/minor when the filesystem _has_ a  
backing block device. If it's initramfs or tmpfs: there isn't one. If  
it's nfs, smbfs, or v9fs: there isn't one.

Rob