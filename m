Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3DWUSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:18:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36944 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3DWUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:18:39 -0400
Date: Tue, 23 Apr 2013 21:18:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: question about buffer_busy check
Message-ID: <20130423201836.GM4068@ZenIV.linux.org.uk>
References: <8738uh5va9.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738uh5va9.fsf@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:41:18PM +0400, Dmitry Monakhov wrote:
> The only guess I have is that this is a miss typo  because buffer
> is busy if some one hold an reference (bh->b_count !=0 )  ||
> it is (dirty | locked). So following patch

... is pointless.  All callers only care about the return value being
zero or non-zero and not about specific values.  Granted, doing it that
way is a micro-optimization, but it's still a valid one.
