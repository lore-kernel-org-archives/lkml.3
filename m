Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbaD2PCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:02:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50748 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaD2PCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:02:51 -0400
Date: Tue, 29 Apr 2014 18:02:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mateusz Guzik <mguzik@redhat.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, Laurent Navet <laurent.navet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140429150226.GU4963@mwanda>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
 <20140427173932.GP26890@mwanda>
 <20140427200042.GA23846@mguzik.redhat.com>
 <20140427224425.GQ26890@mwanda>
 <s5h38gw9or4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h38gw9or4.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah.  If this were a brand new driver then returning -EINVAL would be a
good idea.

Smatch actually warns about this code as well if you turn on the
--spammy option.  But there are too many of these kinds of warnings and
even I can't check them all so the warning is basically useless.

In a few months I will have improved the Smatch code to know that the
source string is too large so this bug could have been avoided.

regards,
dan carpenter
