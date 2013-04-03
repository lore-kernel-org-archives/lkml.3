Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224Ab3DCMaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:30:13 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50568 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab3DCMaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:30:11 -0400
Date: Wed, 03 Apr 2013 07:30:08 -0500
From: Rob Landley <rob@landley.net>
Subject: [RFC] rootmpfs
To: linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.11
Message-Id: <1364992208.18069.18@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is my quick and dirty hack to make rootfs be tmpfs when  
CONFIG_TMPFS is
enabled. It can't be this easy or somebody would have done it in the  
_eight_years_
since https://lkml.org/lkml/2006/7/31/145

Yes, it's got an #ifdef and out of place prototypes. Yes, it manually  
calls a module
init function and compensates by making it reentrant. But it works, and  
when I
"cat /dev/zero > filename" the filesystem fills _up_ instead of  
panicing the kernel.

So now that I've posted the error, would someone please tell me how I  
_should_ have done it?

Rob

P.S. If I actually change the filesystem type to a name other than  
"rootfs", it panics on the way up because various bits of the kernel  
are looking for that magic name. Sigh.

P.P.S. removing MS_NOUSER is actually intentional, there's a local cray  
patch that does the same thing because otherwise you can't --bind mount  
directories out of this filesystem, which is a thing they wanted to do.