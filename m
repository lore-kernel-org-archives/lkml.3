Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaJVUeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:34:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbaJVUeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:34:04 -0400
Message-ID: <544814B7.5000300@nod.at>
Date: Wed, 22 Oct 2014 22:33:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix d_splice_alias() return
 code checking
References: <1413715184-30196-1-git-send-email-richard@nod.at>	<1413715184-30196-2-git-send-email-richard@nod.at> <20141020161219.e68870b37a4a45dbf1e89db8@linux-foundation.org>
In-Reply-To: <20141020161219.e68870b37a4a45dbf1e89db8@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.10.2014 um 01:12 schrieb Andrew Morton:
> On Sun, 19 Oct 2014 12:39:44 +0200 Richard Weinberger <richard@nod.at> wrote:
> 
>> d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
>> Currently the code checks not for ERR_PTR and my oops in
>> ocfs2_dentry_attach_lock().
> 
> It's unclear what the second sentence is trying to tell us.  The patch
> fixes an oops?  If so, a copy of the trace would be useful, as would an
> explanation of why it occurred.  If not, I'm all confused.

ocfs2_dentry_attach_lock() derefs the dentry pointer.
If d_splice_alias() returns ERR_PTR(-EIO) it will oops.

Thanks,
//richard
