Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaCDWuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:50:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaCDWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:50:38 -0500
Date: Tue, 4 Mar 2014 14:50:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: David Miller <davem@davemloft.net>, rgb@redhat.com, eparis@redhat.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
Message-Id: <20140304145037.d46ee775d293dd1ad60aa8e3@linux-foundation.org>
In-Reply-To: <87mwh5d1tf.fsf@xmission.com>
References: <874n3ir0uw.fsf_-_@xmission.com>
	<87mwhaplo4.fsf_-_@xmission.com>
	<20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
	<20140304.165122.445822929490466603.davem@davemloft.net>
	<87mwh5d1tf.fsf@xmission.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2014 14:41:16 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:

> David Miller <davem@davemloft.net> writes:
> 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Date: Tue, 4 Mar 2014 13:30:04 -0800
> >
> >> On Fri, 28 Feb 2014 20:50:19 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:
> >> 
> >>> 
> >>> Modify audit_send_reply to directly use a non-blocking send and
> >>> to return an error on failure (if anyone cares).
> >>> 
> >>> Modify audit_list_rules_send to use audit_send_reply and give up
> >>> if we can not send a packet.
> >>> 
> >>> Merge audit_list_rules into iaudit_list_rules_send as the code
> >>> is now sufficiently simple to not justify to callers.
> >>> 
> >>> Kill audit_send_list, audit_send_reply_thread because using
> >>> a separate thread for replies is not needed when sending
> >>> packets syncrhonously.
> >> 
> >> Nothing much seems to be happening here?
> 
> Well you picked up the patch that fixes the worst of the bugs that I was
> complaining about.  Beyond that I don't know what makes sense.

Oh, so I did.  I wasn't planning on merging it myself, hoping that
someone who hasaclue will step in.  Help.

