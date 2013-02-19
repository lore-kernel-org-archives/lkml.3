Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab3BSNig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:38:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47772 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3BSNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:38:35 -0500
Date: Tue, 19 Feb 2013 16:38:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Cruz Julian Bishop <cruzjbishop@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] staging: android: ashmem: get_name, set_name not to hold
 ashmem_mutex
Message-ID: <20130219133806.GC9138@mwanda>
References: <CAJsYZ5nnAHW9Uu-ee09ttFZZT-DeBVSiHzUnpwt3ZE0hjTFA=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsYZ5nnAHW9Uu-ee09ttFZZT-DeBVSiHzUnpwt3ZE0hjTFA=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good job fixing the bug.  :)

My one concern would be that in set_name() there is a race caused
by dropping the lock.  It would be better to do that
copy_from_user() first, before taking the lock.  I don't expect this
to actually be a problem in real life.

+       /*
+        * Local variable to hold the name copied from user space
+        * This variable is approx of size 270 bytes, not huge
+        */
+       char local_name[ASHMEM_NAME_LEN];

These obvious comments are not needed.  We trust you do not overflow
the stack.  ;)  Also it's checked automatically during build.

Looks good generally.

regards,
dan carpenter

