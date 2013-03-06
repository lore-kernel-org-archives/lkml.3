Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CFEcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:32:04 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52147 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CFEb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:31:59 -0500
Date: Tue, 5 Mar 2013 20:31:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Will Huck <will.huckk@gmail.com>
cc: Ric Mason <ric.masonn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] ksm: treat unstable nid like in stable tree
In-Reply-To: <51369BB9.6030608@gmail.com>
Message-ID: <alpine.LNX.2.00.1303052024570.29433@eggly.anvils>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils> <alpine.LNX.2.00.1302210019390.17843@eggly.anvils> <51271A7D.6020305@gmail.com> <alpine.LNX.2.00.1302221250440.6100@eggly.anvils> <51303CAB.3080406@gmail.com> <alpine.LNX.2.00.1303011139270.7398@eggly.anvils>
 <51315174.4020200@gmail.com> <alpine.LNX.2.00.1303011833490.23290@eggly.anvils> <51369BB9.6030608@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Will Huck wrote:
> 
> How ksm treat a ksm forked page? IIUC, it's not merged in ksm stable tree. It
> will just be ignore?

No, it's there in the stable tree, as it was before it got forked.  And
when ksmd comes around to find the new mm, it will allocate an rmap_item
for that page in the new mm, and append it to the existing stable_node.

Hugh
