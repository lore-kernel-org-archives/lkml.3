Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3CTPQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:16:09 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61700 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CTPQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:16:07 -0400
Date: Wed, 20 Mar 2013 10:16:03 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] Patches to enable chroot for all users
To: Tal Tchwella <tal.tchwella@gmail.com>
Cc: linux-kernel@vger.kernel.org, tchwella@mit.edu
References: <1363784025-23870-1-git-send-email-tchwella@mit.edu>
In-Reply-To: <1363784025-23870-1-git-send-email-tchwella@mit.edu> (from
	tal.tchwella@gmail.com on Wed Mar 20 07:53:42 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363792563.15703.50@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 07:53:42 AM, Tal Tchwella wrote:
> I want to suggest adding chroot capability to all users.

I note that chroot doesn't quite do what most people think it does:

   http://landley.net/notes-2011.html#02-06-2011

I've had a todo item forever to modify chroot to actually change the  
process-local mount tree, creating a bind mount if necessary for the  
new directory, reparenting the mount tree to that bind mount, and  
making sure that reference counting can free unused mounts that this  
would discard. (Except rootfs always needs a nonzero reference count.)

The problem isn't adding security checks, the problem is that having a  
"/" symlink point somewhere _other_ than the actual top of the  
process-local mount tree is obsolete now that there isn't a single  
global mount tree for all processes. (Yes, this would mean it might  
need to create a new namespace.)

Rob