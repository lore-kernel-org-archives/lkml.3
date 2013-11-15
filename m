Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3KOEap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:30:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3KOEai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:30:38 -0500
Message-ID: <5285A33C.4040808@oracle.com>
Date: Fri, 15 Nov 2013 12:29:48 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        jfs-discussion@lists.sourceforge.net, oleg@redhat.com,
        jiri@resnulli.us, gregkh@linuxfoundation.org
Subject: [PATCH 0/6] list: introduce list_last_entry_or_null()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

This patch is trying to introduce a new list helper to retrieve the
last entry or return NULL if the list is empty corresponding to it,
which is inspired by Jiri Pirko's list_first_entry_or_null().

With this trivial helper, we could get a little benefit to simplify
the code logic of xfs_ail_max() and make the code looks a bit more
consistent with xfs_ail_min() which has already been simplified
via list_first_entry_or_null().

Moreover, as a per simple grep against fs as well as driver's tree,
I think there are some other places could make use of it for similar
purpose, here I spread this helper over some file systems as well.

Any comments are welcome!

Thanks,
-Jeff
