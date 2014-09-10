Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaIJNV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:21:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51306 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaIJNV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:21:26 -0400
Date: Wed, 10 Sep 2014 14:21:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Voytik <voytikd@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: seq_file: optimize seq_pad()
Message-ID: <20140910132123.GZ7996@ZenIV.linux.org.uk>
References: <1410340819-18338-1-git-send-email-voytikd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410340819-18338-1-git-send-email-voytikd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:20:19PM +0400, Dmitry Voytik wrote:
> Use seq_putc() instead of seq_printf() in seq_pad() because the
> former is faster.

_Solitary_ seq_putc() is certainly going to be faster, but that loop...
Do you have profiling results, or is it just an apriori "printf must
be sloooowwww"?
