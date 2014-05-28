Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaE1NO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:14:57 -0400
Received: from mail.siteground.com ([67.19.240.234]:36024 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaE1NO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:14:56 -0400
Message-ID: <5385E153.6030607@1h.com>
Date: Wed, 28 May 2014 16:14:59 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] Per user namespace process accounting
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I have the following proposition.

Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that multiple
containers in different user namespaces share the process counters.

So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any
processes with ist own UID 99.

I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps, but
this brings another problem.

We are provisioning the containers from a template. The template has a lot of files 500k and more. And chowning these
causes a lot of I/O and also slows down provisioning considerably.

The other problem is that when we migrate one container from one host machine to another the IDs may be already in use
on the new machine and we need to chown all the files again.

Finally if we use different UID/GID maps we can not do live migration to another node because the UIDs may be already
in use.

So I'm proposing one hack modifying unshare_userns() to allocate new user_struct for the cred that is created for the
first task creating the user_ns and free it in exit_creds().

Can you please comment on that?

Or suggest a better solution?

Best regards,
Marian


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOF4VMACgkQ4mt9JeIbjJSFnwCgrAgCDvBs5ue0BPUHmach04Oo
xgMAn34PJbuVCBwh/RqUumFP05fvMHHy
=5J9M
-----END PGP SIGNATURE-----
