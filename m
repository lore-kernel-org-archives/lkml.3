Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaAPW2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:28:47 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60515 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaAPW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:28:45 -0500
Date: Thu, 16 Jan 2014 14:28:42 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: lsf-pc@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [LSF/MM TOPIC] [ATTEND] Direct IO
Message-ID: <20140116222842.GQ9037@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'd like to discuss the current state and future direction of the DIO code.

I and others have been kicking around the idea for some time now of reworking
direct IO at the filesystem level in terms of bios; this will radically simplify
fs/direct-IO.c, and solve some other longstanding issues, like double usage of
the page cache by the loopback device - the goal will be for things like loop to
just be able to submit bios to the filesystem code.

Immutable biovecs are now almost upstream, which was a major prereq; this helps
enables a DIO rewrite that basically pushes bios up a layer. Soon, we'll need to
start reworking vfs interfaces, and input from the filesystem developers
(especially btrfs) will be necessary there.
