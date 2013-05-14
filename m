Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3ENTEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:04:41 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62325 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3ENTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:04:40 -0400
Date: Tue, 14 May 2013 15:04:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race v5
Message-ID: <20130514190451.GA2907@kroah.com>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
 <1368477007-25274-3-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368477007-25274-3-git-send-email-joern@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 04:30:06PM -0400, Joern Engel wrote:
> It is possible for one thread to to take se_sess->sess_cmd_lock in
> core_tmr_abort_task() before taking a reference count on
> se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> 
> This introduces kref_put_spinlock_irqsave() and uses it in
> target_put_sess_cmd() to close the race window.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>

For the kref.h part, please feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
