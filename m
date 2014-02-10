Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaBJTvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:51:39 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:34481
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753740AbaBJTvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:51:35 -0500
Date: Mon, 10 Feb 2014 20:51:33 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>, stgraber@ubuntu.com,
        apw@canonical.com
Subject: overlayfs mounts in user namespaces
Message-ID: <20140210195133.GA10107@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

most filesystems cannot be mounted in a non-init user namespace because we
don't trust the superblock parsers to DTRT when handed garbage.  I was
wondering if you had any ideas on ways that allowing root in a non-init userns
to mount an overlayfs fs would be dangerous?  There's no superblock parsing in
that case at all;  writes end up being allowed if and only if the userid owning
the 'upper' (writeable) layer is mapped into the userns.  Near as I can tell
it should be quite safe.  But my imagination isn't the most active.

I assume there would be concerns about memory usage if the system is not
configured to place all logged-in users into configured cgroups?  Is there
anything else you can think of that could be abused?

(I realize overlayfs isn't upstream yet so the question may not be all that
interesting to most people...)

thanks,
-serge
