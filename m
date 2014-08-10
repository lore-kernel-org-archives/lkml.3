Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaHJQ4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:56:19 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaHJQ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:56:18 -0400
Message-ID: <53E7A42E.4090702@nod.at>
Date: Sun, 10 Aug 2014 18:56:14 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        sahne@0x90.at
Subject: "resource: provide new functions to walk through resources" breaks
 UML
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Daniel Walter reported that UML is currently broken.
The offending commit is:

commit 8c86e70acead629aacb4afcd818add66bf6844d9
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Fri Aug 8 14:25:50 2014 -0700

    resource: provide new functions to walk through resources

It dies in next_resource():
        /* Caller wants to traverse through siblings only */
        if (sibling_only)
                return p->sibling;

because p is NULL.
Please note that UML has no iomem, maybe this is the problem...

Thanks,
//richard
