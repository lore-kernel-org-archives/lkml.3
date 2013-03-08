Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3CHEfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:35:00 -0500
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:46400 "EHLO
	homiemail-a47.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756010Ab3CHEe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:34:59 -0500
X-Greylist: delayed 48852 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 23:34:59 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 23:34:58 -0500
From: shea@shealevy.com
To: <linux-fsdevel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re-mounting a non-bind mountpoint with =?UTF-8?Q?MS=5FBIND?=
Message-ID: <25c50eb5327aea8fc70b29fd0853befb@shealevy.com>
User-Agent: Roundcube Webmail/0.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To my surprise, mount("/dev/sda1", "/mnt", "vfat", MS_RDONLY, "") 
followed by mount("/mnt", "/mnt", 0, MS_REMOUNT | MS_BIND, 0) succeeds, 
with some IMO odd behavior:

* statfs(2) on /mnt shows /mnt as not being readonly in the s_flags 
field
* The sixth column of relevant mountinfo files (but not the tenth!) 
shows /mnt as being rw
* All other syscalls (AFAICT, I checked with git grep MNT_READONLY) 
behave as if /mnt were readonly

Why does mount behave like this? To me it would make much more sense if 
either MS_REMOUNT | MS_BIND failed on a non-bind mountpoint (my personal 
preference) or if it succeeded but the mountpoint was still treated as 
readonly from the perspective of all userspace interfaces.

Cheers,
Shea Levy

P.S. I am not subscribed to fsdevel or lkml, so please CC me in 
responses.
